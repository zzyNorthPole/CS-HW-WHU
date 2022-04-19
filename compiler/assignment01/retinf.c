/* retinf.c   	AXL分析器 */
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "lex.h"

char err_id[] = "error";
char * midexp;
extern char * yytext;

struct YYLVAL {
  char * val;  /* 记录表达式中间临时变量 */
  char * expr; /* 记录表达式后缀式 */
  int last_op;  /* last operation of expression 
		   for elimination of redundant parentheses */
};

typedef struct YYLVAL Yylval;

Yylval * expression ( void );

char *newname( void ); /* 在name.c中定义 */

extern void freename( char *name );

void statements ( void )
{
  /*  statements -> expression SEMI  |  expression SEMI statements  */
  /*  请完成！！！*/
  Yylval *temp;
  printf("Please input an affix expression and ending with \";\"\n");
  while( !match(EOI) )    {
    temp = expression();
    printf("the infix expression is %s\n", temp->expr);
    freename(temp->val);
    free(temp->expr);
	free(temp);   
	//advance();
    if( !match( SEMI ) ){
	  advance();
      printf("Please input an affix expression and ending with \";\"\n");
	  if (match(SEMI)) advance();
    }
    else {
      fprintf( stderr, "%d: Inserting missing semicolon\n", yylineno );
	  advance();
	}
  }
}

Yylval *expression()
{ 
  /*
    expression -> PLUS expression expression
               |  MINUS expression expression
               |  TIMES expression expression
               |  DIVISION expression expression
	       |  NUM_OR_ID
  */
  /*  请完成！！！*/
	Yylval *temp = NULL, *temp2 = NULL;
	char *tmpvar = NULL, *tmpexpr = NULL, *tmpvar2 = NULL, *tmpexpr2 = NULL, *tmpexpr1 = NULL;

	int flag = 0;
	while (match(PLUS) || match(MINUS) || match(TIMES) || match(DIVISION)) {
		flag = 1;
		char op = yytext[0];
		
		advance();
		if (match(PLUS) || match(MINUS) || match(TIMES) || match(DIVISION)) {
			temp = expression();
		}
		else {
			tmpvar = newname();
			tmpexpr = (char *) malloc(sizeof(yyleng + 1));
			strncpy(tmpexpr, yytext, yyleng);
			tmpexpr[yyleng] = 0;

			printf("    %s = %s\n", tmpvar, tmpexpr);
			
			temp = (Yylval *) malloc(sizeof(Yylval));
			temp->val = tmpvar;
			temp->expr = tmpexpr;
			temp->last_op = 0;
		}

		advance();
		if (match(PLUS) || match(MINUS) || match(TIMES) || match(DIVISION)) {
			temp2 = expression();
		}
		else {
			tmpvar2 = newname();
			if (match(NUM_OR_ID)) {
				tmpexpr2 = (char *) malloc(sizeof(yyleng + 1));
				strncpy(tmpexpr2, yytext, yyleng);
				tmpexpr2[yyleng] = 0;
			}
			else {
				printf("error!\n");
				tmpexpr2 = (char *) malloc(sizeof(6));
				strncpy(tmpexpr2, "(null)", 6);
				tmpexpr2[6] = 0;
			}

			printf("    %s = %s\n", tmpvar2, tmpexpr2);
			
			temp2 = (Yylval *) malloc(sizeof(Yylval));
			temp2->val = tmpvar2;
			temp2->expr = tmpexpr2;
			temp2->last_op = 0;
		}

		printf("    %s %c= %s\n", temp->val, op, temp2 ->val);
		if (op == '*' || op == '/') {
			int flag1 = 0, flag2 = 0;
			if (temp->last_op == PLUS || temp->last_op == MINUS) flag1 = 1;
			if (temp2->last_op == PLUS || temp2->last_op == MINUS) flag2 = 1; 
			
			tmpexpr1 = (char *) malloc(strlen(temp2->expr) + strlen(temp->expr) + 4 + flag1 * 2 + flag2 * 2);
			if (flag1 && flag2) 
				sprintf(tmpexpr1, "(%s) %c (%s)", temp->expr, op, temp2->expr);
			else if (flag1 && !flag2) 
				sprintf(tmpexpr1, "(%s) %c %s", temp->expr, op, temp2->expr);
			else if (!flag1 && flag2) 
				sprintf(tmpexpr1, "%s %c (%s)", temp->expr, op, temp2->expr);
			else 
				sprintf(tmpexpr1, "%s %c %s", temp->expr, op, temp2->expr);
			
			if (op == '*') temp->last_op = TIMES;
			else temp->last_op = DIVISION;
		}
		else {
			if (op == '-' && (temp2->last_op == MINUS || temp2->last_op == PLUS)) {
				tmpexpr1 = (char *) malloc(strlen(temp2->expr) + strlen(temp->expr) + 4 + 2);
				sprintf(tmpexpr1, "%s %c (%s)", temp->expr, op, temp2->expr);
			}
			else {
				tmpexpr1 = (char *) malloc(strlen(temp2->expr) + strlen(temp->expr) + 4);
				sprintf(tmpexpr1, "%s %c %s", temp->expr, op, temp2->expr);
			}
			
			if (op == '+') temp->last_op = PLUS;
			else temp->last_op = MINUS;
		}
		freename(temp2->val);
		if (temp2->expr) free(temp2->expr);
		if (temp2) free(temp2);
		temp->expr = tmpexpr1;
		if (tmpexpr) free(tmpexpr);
	}

	if (!flag) {
		tmpvar = newname();
		tmpexpr = (char *) malloc(sizeof(yyleng + 1));
		strncpy(tmpexpr, yytext, yyleng);
		tmpexpr[yyleng] = 0;

		printf("    %s = %s\n", tmpvar, tmpexpr);
			
		temp = (Yylval *) malloc(sizeof(Yylval));
		temp->val = tmpvar;
		temp->expr = tmpexpr;
		temp->last_op = 0;
	}
	return temp;
}