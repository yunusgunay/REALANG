%{
#include <stdio.h>
#include <string.h>
int yylex();
int yyerror(const char *s);
extern int yylineno;
%}
/* Enables verbose error messages */
%error-verbose

/* Token Declarations */
%token START END
%token IF ELSE WHILE FOR FUNCTION RETURN INPUT PRINT REAL
%token LIST ADD_FUNC REMOVE_FUNC GET_FUNC SIZE_FUNC
%token PLUS MINUS REF
%token ASSIGN NOT MUL DIV MOD POW AND OR
%token EQUALS NOT_EQUALS LESS_EQUAL GREATER_EQUAL LESS_THAN GREATER_THAN
%token LP RP LBRACE RBRACE LBRACK RBRACK COMMA SC
%token REAL_NUM INT STRING IDENTIFIER COMMENT

/* Precedence & Associativity */
%left OR
%left AND
%right NOT
%left EQUALS NOT_EQUALS LESS_THAN GREATER_THAN LESS_EQUAL GREATER_EQUAL
%left PLUS MINUS
%left MUL DIV MOD
%right POW
%right UPLUS UMINUS
%nonassoc ELSE

%start program

%%

program
    : START statement_list END
        { printf("Input program is valid\n"); }
    ;

statement_list
    : statement
    | statement_list statement 
    ;

statement
    : declaration
    | assignment
    | conditional
    | loop_stmt
    | io_stmt
    | function_def
    | return_stmt
    | list_declaration
    | list_func
    | comment
    ;

/* Declarations & Assignments */
declaration
    : REAL assignment
    | REAL identifier_list SC
    ;

identifier_list
    : IDENTIFIER
    | identifier_list COMMA IDENTIFIER
    ;

assignment
    : IDENTIFIER ASSIGN real_expr SC
    ;

/* Conditional */
conditional
    : matched_if
    | unmatched_if
    ;

matched_if
    : IF LP logical_expr RP block ELSE matched_if
    | IF LP logical_expr RP block ELSE block
    ;

unmatched_if
    : IF LP logical_expr RP block
    | IF LP logical_expr RP block ELSE unmatched_if
    ;

/* Block */
block
    : LBRACE statement_list RBRACE
    ;

/* Loops */
loop_stmt
    : WHILE LP logical_expr RP block
    | FOR LP for_dec SC logical_expr SC for_assign RP block
    ;

for_dec
    : REAL for_assign
    | for_assign
    ;

for_assign
    : IDENTIFIER ASSIGN real_expr
    ;

/* IO */
io_stmt
    : input_stmt
    | output_stmt
    ;

input_stmt
    : IDENTIFIER ASSIGN INPUT LP RP SC
    ;

output_stmt
    : PRINT LP print_args RP SC
    ;

print_args
    : STRING
    | real_expr
    | print_args COMMA STRING
    | print_args COMMA real_expr
    ;

/* Function Definitions */
function_def
    : FUNCTION IDENTIFIER LP parameter_list_opt RP block
    ;

parameter_list_opt
    : /* empty */
    | parameter_list
    ;

parameter_list
    : parameter
    | parameter_list COMMA parameter
    ;

parameter
    : REAL IDENTIFIER
    | REAL REF IDENTIFIER
    ;

return_stmt
    : RETURN real_expr SC
    ;

/* Data Structure */
list_declaration
    : LIST IDENTIFIER ASSIGN LBRACE real_list_opt RBRACE SC
    ;

real_list_opt
    : /* empty */
    | real_list
    ;

real_list
    : real_expr
    | real_list COMMA real_expr
    ;

list_func
    : IDENTIFIER ADD_FUNC LP real_expr RP SC
    | IDENTIFIER REMOVE_FUNC LP real_expr RP SC
    ;

/* Comments */
comment
    : COMMENT
    ;

/* Logical Expressions */
logical_expr
    : logical_expr OR logical_term
    | logical_term
    ;

logical_term
    : logical_term AND logical_factor
    | logical_factor
    ;

logical_factor
    : NOT logical_factor
    | LP logical_expr RP
    | real_expr comparison_op real_expr
    ;

comparison_op
    : EQUALS
    | NOT_EQUALS
    | LESS_EQUAL
    | GREATER_EQUAL
    | LESS_THAN
    | GREATER_THAN
    ;

/* Real Expressions */
real_expr
    : real_expr PLUS term
    | real_expr MINUS term
    | term
    ;

term
    : term MUL factor_term
    | term DIV factor_term
    | term MOD factor_term
    | factor_term
    ;

factor_term
    : factor_term POW factor_term
    | factor
    ;

factor
    : unary_op primary
    | primary
    ;

unary_op
    : PLUS   %prec UPLUS
    | MINUS  %prec UMINUS
    ;

primary
    : REAL_NUM
    | INT
    | IDENTIFIER
    | LP real_expr RP
    | function_call
    | list_expr
    ;

/* Function Calls */
function_call
    : IDENTIFIER LP argument_list_opt RP
    ;

argument_list_opt
    : /* empty */
    | argument_list
    ;

argument_list
    : argument
    | argument_list COMMA argument
    ;

argument
    : real_expr
    | REF IDENTIFIER
    ;

/* List Expressions */
list_expr
    : IDENTIFIER GET_FUNC LP index_term RP
    | IDENTIFIER SIZE_FUNC LP RP
    ;

index_term
    : index_factor
    | index_term PLUS index_factor
    | index_term MINUS index_factor
    ;

index_factor
    : index_primary
    | index_factor MUL index_primary
    | index_factor DIV index_primary
    | index_factor MOD index_primary
    ;

index_primary
    : INT
    | IDENTIFIER
    | LP index_term RP
    ;

%%
#include "lex.yy.c"

int yyerror(const char *s) {
    fprintf(stderr, "Syntax error on line %d!\n", yylineno);
    return 1;
}

int main() {
    yyparse();
    return 0;
}
