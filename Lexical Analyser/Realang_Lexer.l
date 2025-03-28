%{
#include <stdio.h>
%}

SINGLE_COMMENT  ("//").*
MULTI_COMMENT   "/*"([^*]|\*+[^/])*\*+"/"
STRING_LITERAL  \"([^\\\"\n]|(\\.))*\"
NEWLINE         [\n]+

%%
if          printf("IF ");
else        printf("ELSE ");
while       printf("WHILE ");
for         printf("FOR ");
function    printf("FUNCTION ");
return      printf("RETURN ");
input       printf("INPUT ");
print       printf("PRINT ");
start       printf("START\n");
end         printf("\nEND");

list            printf("LIST_TYPE ");
\.add           printf("ADD_FUNC ");
\.remove        printf("REMOVE_FUNC ");
\.getRealNum    printf("GET_FUNC ");
\.getSize       printf("SIZE_FUNC ");

\+  printf("PLUS ");
\-  printf("MINUS ");

\=      printf("ASSIGN_OP ");
\!      printf("NOT_OP ");
\*      printf("MUL_OP ");
\/      printf("DIV_OP ");
\%      printf("MOD_OP ");
\^      printf("POW_OP ");
\&\&    printf("AND_OP ");
\|\|    printf("OR_OP ");

\=\=    printf("EQUALS ");
\!\=    printf("NOT_EQUALS ");
\<\=    printf("LESS_EQUAL ");
\>\=    printf("GREATER_EQUAL ");
\<      printf("LESS_THAN ");
\>      printf("GREATER_THAN ");

\(  printf("LP ");
\)  printf("RP ");
\{  printf("LBRACE ");
\}  printf("RBRACE ");
\[  printf("LBRACK ");
\]  printf("RBRACK ");
\,  printf("COMMA ");
\;  printf("SC ");

[0-9]+(\.[0-9]*)?|\.[0-9]+  printf("REAL_NUM ");
{STRING_LITERAL}            printf("STRING ");
[a-zA-Z_][a-zA-Z0-9_]*      printf("IDENTIFIER ");

{SINGLE_COMMENT}    printf("COMMENT ");
{MULTI_COMMENT}     printf("COMMENT ");
{NEWLINE}           ;
[ \t\r]+            ;
.                   printf("UNKNOWN(%s) ", yytext);

%%
int main() {
    yylex();
    return 0;
}

int yywrap(void) {
    return 1;
}