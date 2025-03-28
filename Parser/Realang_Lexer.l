%{
#include <stdio.h>
#include "y.tab.h"
extern int yylineno;
%}

SINGLE_COMMENT  ("//").*
MULTI_COMMENT   "/*"([^*]|\*+[^/])*\*+"/"
STRING_LITERAL  \"([^\\\"\n]|(\\.))*\"
NEWLINE         [\n]+

%%
if          { return IF; }
else        { return ELSE; }
while       { return WHILE; }
for         { return FOR; }
function    { return FUNCTION; }
return      { return RETURN; }
input       { return INPUT; }
print       { return PRINT; }
real        { return REAL; }
start       { return START; }
end         { return END; }

list            { return LIST; }
\.add           { return ADD_FUNC; }
\.remove        { return REMOVE_FUNC; }
\.getRealNum    { return GET_FUNC; }
\.getSize       { return SIZE_FUNC; }

\+      { return PLUS; }
\-      { return MINUS; }
\&      { return REF; }

\=      { return ASSIGN; }
\!      { return NOT; }
\*      { return MUL; }
\/      { return DIV; }
\%      { return MOD; }
\^      { return POW; }
\&\&    { return AND; }
\|\|    { return OR; }

\=\=    { return EQUALS; }
\!\=    { return NOT_EQUALS; }
\<\=    { return LESS_EQUAL; }
\>\=    { return GREATER_EQUAL; }
\<      { return LESS_THAN; }
\>      { return GREATER_THAN; }

\(  	{ return LP; }
\)  	{ return RP; }
\{  	{ return LBRACE; }
\}  	{ return RBRACE; }
\[  	{ return LBRACK; }
\]  	{ return RBRACK; }
\,  	{ return COMMA; }
\;  	{ return SC; }

[0-9]+                      { return INT; }
[0-9]+(\.[0-9]*)?|\.[0-9]+  { return REAL_NUM; }
{STRING_LITERAL}            { return STRING; }
[a-zA-Z_][a-zA-Z0-9_]*      { return IDENTIFIER; }

{SINGLE_COMMENT}    { return COMMENT; }
{MULTI_COMMENT}     { return COMMENT; }
{NEWLINE}       { 
                    int i;
                    for(i = 0; i < yyleng; i++) {
                        if(yytext[i] == '\n') yylineno++;
                    }
                }
                
[ \t\r]+            ;
.                   { return yytext[0]; }

%%
int yywrap(void) {
    return 1;
}