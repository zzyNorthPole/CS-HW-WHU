
CC = gcc

all: lambda1
COMOBJ = y.tab.o lex.yy.o emalloc.o tree.o type.o closure.o

# ------------------------------------------------------------

.c.o:
	 $(CC)  -pg  -Wall $(INCLUDE) -c $(CFLAGS) $(MODEL) $*.c

#------------------------------------------------------------

lex.yy.c:  lexer.l
	flex  lexer.l

y.tab.c y.tab.h:  grammar.y
	byacc -tvd grammar.y
#------------------------------------------------------------

lambda1:  $(COMOBJ) 
	$(CC) -pg -o lambda1 $(LIB) $(MODEL) $(COMOBJ) $(CLIB)

# ----------------------------------------------------------------------

clean: 
	rm *.o y.tab.c y.tab.h lex.yy.c
#

emalloc.o: emalloc.c
lex.yy.o: lex.yy.c tree.h y.tab.h
tree.o: tree.c tree.h
closure.o: tree.h closure.c
y.tab.o: y.tab.c tree.h 


