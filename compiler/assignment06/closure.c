/************************************************************/
/*      copyright hanfei.wang@gmail.com                     */
/*             2020.11.23                                   */
/************************************************************/


#include "tree.h"
#include "closure.h"
extern FILE* eval_tree;
CLOSURE *make_clos(AST *tree, CLOSURE_LIST *env, int index)
{
  CLOSURE * new = (CLOSURE *) smalloc(sizeof(CLOSURE));
  new -> ast = tree;
  new -> env = env;
  new -> index = index;
  return new;
}

CLOSURE_LIST *make_list(CLOSURE *clos, CLOSURE_LIST *env)
{
  CLOSURE_LIST * new = (CLOSURE_LIST *) smalloc(sizeof(CLOSURE_LIST));
  new -> clos = clos;
  new -> next = env;
  return new;
}

AST *clone_tree(AST * source)
{
  while (source != NULL) {
    switch(source -> kind) {
    case CONST: return make_const(source -> value);
    case VAR: return make_var(source -> value);
    case COND: 
      return make_cond(clone_tree(source -> cond),
                       clone_tree(source -> lchild),
		       clone_tree(source -> rchild));
    case ABS: return make_abs(NULL, clone_tree(source -> rchild));
    default: return make_app(clone_tree(source -> lchild),
			     clone_tree(source -> rchild));		       
    }
  }
  return NULL;
}

CLOSURE_LIST *clone_list(CLOSURE_LIST *source);

CLOSURE *clone_clos(CLOSURE *source)
{
  if (source == NULL) return NULL;
  return make_clos(clone_tree(source -> ast), 
		   clone_list(source -> env),
		   source -> index);
}

CLOSURE_LIST *clone_list(CLOSURE_LIST *source)
{
  if (source == NULL) return NULL;
  return make_list(clone_clos(source -> clos), clone_list(source -> next));
}

void free_list(CLOSURE_LIST *list);

void free_clos(CLOSURE *clos)
{
  if (clos == NULL) return;
  free_ast(clos -> ast);
  free_list(clos -> env);
  sfree(clos);
  return;
}

void free_list(CLOSURE_LIST *list)
{
  if (list != NULL) {
    free_clos(list -> clos);
    free_list(list -> next);
    sfree(list);
  }
  return;
}

/* AST tree for the primitive like:
             ABS
              |
         +----+----+
         |         |
         x        ABS
                   |
              +----+----+
              |         |
              y         n
     where n = 0, -1, -2, -3, -4, -5
           op  +,  -,  *,  /,  =,  <
    
 */ 

static char X[] = "x", Y[] = "y";

AST *make_op(int op)
{
  AST *tmp = make_var(op);
  return make_abs(X, make_abs(Y, tmp));
}

CLOSURE  *global_eval_env[MAX_ENV];

void init_eval()
{
  int i = 0;
  CLOSURE_LIST *list = NULL, *tmp;
  while (i < INIT_POS) {
    CLOSURE *new = make_clos(make_op(-i), NULL, i + 1);    
    global_eval_env[i] = new;
    i++;
    }
  return;
}


void print_list(CLOSURE_LIST * list);

void print_closure(CLOSURE *clos)
{
  if (clos -> env == NULL) {
    print_expression(clos -> ast, stdout);
    return;
  }
  printf("<"); 
  print_expression(clos -> ast, stdout);
  printf(", ");
  print_list(clos -> env);
  printf(">");
  return;
}


void print_list(CLOSURE_LIST * list)
{
  printf("[");
  while (list != NULL) {
    print_closure(list -> clos);
    list = list -> next;
    if (list != NULL) printf("; ");
  }
  printf("]");
  return;
}

CLOSURE *get_global(int i)
{
  return clone_clos(global_eval_env[i]);
  /* always get the copy of env */
}

CLOSURE *get_argument(int n, CLOSURE_LIST *env, int index)
{
  int i = 0;
  while ( i != n -1 && env != NULL  ) {
    env = env -> next;
    i ++;
  }
  
  if (i == n - 1  && env != NULL)  return clone_clos(env -> clos);

  if (index -(n -i) >=0 ) return get_global(index - n + i ); 
  /* n + i is top of stack */
  printf("wrong access closure env\n");
  exit (1);
  /* always get the copy of env */
}

CLOSURE *cbv_primitive(CLOSURE * clos)
{
  CLOSURE_LIST *env = clos -> env;
  int index = clos -> index;
  CLOSURE *x_arg = get_argument(1, env, 0),
    *y_arg = get_argument(2, env, 0);
  int op = clos -> ast -> value;
  int x, y, z;
  if (x_arg -> ast -> kind != CONST && y_arg -> ast -> kind != CONST) {
    free_clos(x_arg);
    free_clos(y_arg);
    return clos;
  }
  x = x_arg -> ast -> value; y = y_arg -> ast -> value;
  switch (op) {
    case -5: z = y < x ? 1 : 0; break;
    case -4: z = (y == x); break;
    case -3: z = y / x; break;
    case -2: z = y * x; break;
    case -1: z = y - x; break;
    default: z = y + x;
    }
  free_clos(x_arg);
  free_clos(y_arg);
  free_clos(clos);
  return make_clos(make_const(z), NULL, 0);
}




CLOSURE *eval_cbv(CLOSURE *clos)
{
  AST *exp = clos->ast;
  CLOSURE_LIST *env = clos->env;
  CLOSURE *result, *C, *M, *N, *tmp;
  int index = clos->index;
  step++; /* step is define in type.c */
  /* todo */
  switch (exp->kind) {
    case CONST:
      free_list(env);
      clos->env = NULL;
      return clos;
    case VAR:
      if (exp -> value <= 0) {
        result = cbv_primitive(clos);
        return result;
      }
      result = get_argument(exp->value, env, index);
      free_clos(clos);
      return result;
    case ABS:
      return clos;
    case COND:
      C = make_clos(clone_tree(exp->cond), clone_list(env), index);
      C = eval_cbv(C);
      if (C->ast->value) result = eval_cbv(make_clos(clone_tree(exp->lchild), clone_list(env), index));
      else result = eval_cbv(make_clos(clone_tree(exp->rchild), clone_list(env), index));
      free_clos(clos);
      return result;
    default:
      M = make_clos(clone_tree(exp->lchild), clone_list(env), index);
      M = eval_cbv(M);
      N = make_clos(clone_tree(exp->rchild), clone_list(env), index);
      N = eval_cbv(N);
      tmp = make_clos(M->ast->rchild, make_list(N, M->env), M->index);
      result = eval_cbv(tmp);
      free_clos(clos);
      return result;
  }
}

void free_cbn_env(CBN_ENV *clos)
{
  if (clos == NULL) return;
  free_list(clos -> stack);
  free_clos(clos -> cbn_env);
  sfree(clos);
  return;
}

CBN_ENV *make_cbn_env(CLOSURE *clos, CLOSURE_LIST *stack)
{
  CBN_ENV *new = (CBN_ENV *) smalloc(sizeof(CBN_ENV));
  new -> cbn_env = clos;
  new -> stack = stack;
  return new;
}

CLOSURE *cbn_primitive(CLOSURE * clos)
{
  CLOSURE_LIST *env = clos -> env;
  CLOSURE *x_arg = get_argument(1, env, 0),
    *y_arg = get_argument(2, env, 0);
  int op = clos -> ast -> value;
  CBN_ENV *x_res = NULL, *y_res = NULL;
  int x, y, z;

  /* call eval_cbn until to a constant */
  x_res = eval_cbn(make_cbn_env(x_arg, NULL));
  x_arg = x_res -> cbn_env;
  
  y_res = eval_cbn(make_cbn_env(y_arg, NULL));
  y_arg = y_res -> cbn_env;
  
  if (x_arg -> ast -> kind != CONST && y_arg -> ast -> kind != CONST) {
    printf("can't be evualated to constant!\n");
    exit(1);
  }

  x = x_arg -> ast -> value; y = y_arg -> ast -> value;
  switch (op) {
    case -5: z = y - x ? 1 : 0; break;
    case -4: z = (y == x); break;
    case -3: z = y / x; break;
    case -2: z = y * x; break;
    case -1: z = y - x; break;
    default: z = y + x;
    }
  free_clos(clos);
  free_cbn_env(x_res);
  free_cbn_env(y_res);
  return make_clos(make_const(z), NULL, 0);
}

void print_cbn_env( CBN_ENV * clos)
{
  print_closure(clos -> cbn_env);
  printf(";### ");
  print_list(clos -> stack);
  printf("###\n");
}

CBN_ENV *eval_cbn(CBN_ENV *clos)
{
  step++;
  /* todo */
  AST *exp = clos->cbn_env->ast;
  CLOSURE_LIST *env = clos->cbn_env->env;
  CLOSURE_LIST *stack = clos->stack;
  CBN_ENV *result;
  CLOSURE *tmp, *M, *N, *C;
  int index = clos->cbn_env->index;
  //printf("%d ", exp->kind);
  //print_cbn_env(clos);
  //printf("finish now\n");
  switch (exp->kind) {
  case CONST:
    free_list(env);
    clos->cbn_env->env = NULL;
    return clos;
  case VAR:
    if (exp->value <= 0) {
      result = make_cbn_env(cbn_primitive(clos->cbn_env), stack);
      return result;
    }
    result = eval_cbn(make_cbn_env(get_argument(exp->value, env, index), stack));
    free_clos(clos->cbn_env);
    return result;
  case ABS:
    //printf("ABS now\n");
    tmp = get_argument(1, stack, index);
    //printf("Wa now\n");
    if (stack == NULL) return clos;
    stack = stack->next;
    exp = exp->rchild;
    env = make_list(tmp, env);
    result = eval_cbn(make_cbn_env(make_clos(exp, env, index), stack));
    //print_cbn_env(result);
    return result;
  case COND:
    C = make_clos(clone_tree(exp->cond), clone_list(env), index);
    C = eval_cbn(make_cbn_env(C, stack))->cbn_env;
    if (C->ast->value)
      result = eval_cbn(make_cbn_env(make_clos(clone_tree(exp->lchild), clone_list(env), index), stack));
    else
      result = eval_cbn(make_cbn_env(make_clos(clone_tree(exp->rchild), clone_list(env), index), stack));
    free_cbn_env(clos);
    return result;
  default:
    M = make_clos(clone_tree(exp->lchild), clone_list(env), index);
    N = make_clos(clone_tree(exp->rchild), clone_list(env), index);
    result = eval_cbn(make_cbn_env(M, make_list(N, stack)));
    free_cbn_env(clos);
    //print_cbn_env(result);
    return result;
  }
}