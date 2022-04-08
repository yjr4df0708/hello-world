%{
#include "interpreter.tab.c"
#include <stdlib.h>
#include <string.h>
int layer=0;
%}
%s ESC PROC
M_NAME					[A-Z0-9_]+
VARNAME					[a-z_][A-Za-z0-9_]*
INT						([0-9]+)|("0x"[0-9a-fA-F]+)|("0b"[01]+)
DOUBLE					[0-9]+"."[0-9]+
STR						"\""(("\\"("\\"|"\""|[abefnrtv0]|([0-7]{3})|("x"[0-9a-fA-F]{2})))|[^"\""])*"\""
%%
<PROC>"$"				layer++; return MACRO_START;
<PROC>"\\$"				if(!--layer)BEGIN(0); return MACRO_END;
<PROC>":"				return COLON;
<PROC>","				return COMMA;
<PROC>"("				return LPAREN;
<PROC>")"				return RPAREN;
<PROC>"["				return LBRACKET;
<PROC>"]"				return RBRACKET;
<PROC>"{"				return LCBRACKET;
<PROC>"}"				return RCBRACKET;
<PROC>"^"				return POWER;
<PROC>"*"				return MULT;
<PROC>"/"				return DIV;
<PROC>"+"				return ADD;
<PROC>"-"				return SUB;
<PROC>{M_NAME}			strcpy(yylval.text, yytext); return MACRO_NAME;
<PROC>{VARNAME}			strcpy(yylval.text, yytext); return VAR;
<PROC>{DOUBLE}			yylval._double=strtod(yytext, NULL); return NUM_DOUBLE;
<PROC>{INT}				yyerror(yytext); yylval._int=strtol(yytext, NULL, 0); return NUM_INTEGER;
<PROC>{STR}				strcpy(yylval.text, yytext); return STR;
<PROC>[ \t]+
<PROC>""$				yyerror("unexpected end of line"); BEGIN(0); layer=0;
<PROC><<EOF>>			yyerror("unexpected end of file");
<PROC>.					yyerror(yytext);
<ESC>"$"				BEGIN(0); strcpy(yylval.text, "$"); return PASS;
<ESC>"\\"/"$"			BEGIN(0); strcpy(yylval.text, "\\"); return PASS;
<ESC>.|"\n"				BEGIN(0); strcpy(yylval.text, "\\"); strcat(yylval.text, yytext); return PASS;
<ESC><<EOF>>			BEGIN(0); strcpy(yylval.text, "\\"); return PASS;
<INITIAL>"\\"			BEGIN(ESC);
<INITIAL>"$"			BEGIN(PROC); layer++; return MACRO_START;
<INITIAL>.				strcpy(yylval.text, yytext); return PASS;
