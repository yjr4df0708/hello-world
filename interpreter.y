%{
#include <stdio.h>
int yylex();
int yyerror(char *s);
int yywrap();
%}
%token COLON PASS MACRO_START MACRO_END MACRO_NAME VAR LPAREN RPAREN LBRACKET RBRACKET LCBRACKET RCBRACKET POWER MULT DIV ADD SUB COMMA NUM_INTEGER NUM_DOUBLE STR
%type <text> PASS
%type <text> MACRO_NAME
%type <text> VAR
%type <_int> NUM_INTEGER
%type <_double> NUM_DOUBLE
%type <text> STR
%union{
	char text[256];
	int _int;
	double _double;
}

%%

SCRIPT: | SCRIPT_P | SCRIPT_M ;

SCRIPT_P: PASSALL SCRIPT_M | PASSALL ;

SCRIPT_M: MACRO SCRIPT_M | MACRO SCRIPT_P | MACRO ;

PASSALL: PASSALL PASS {printf("%s", $2);} | PASS {printf("%s", $1);} ;

MACRO: MACRO_START MACRO_NAME COLON EXPRS MACRO_END | MACRO_START MACRO_NAME COLON MACRO_END ;

EXPRS: EXPR_L4 | EXPR_L4 COMMA EXPRS ;

L4: ADD | SUB ;
EXPR_L4: EXPR_L4 L4 EXPR_L3 | EXPR_L3 ;

L3: MULT | DIV ;
EXPR_L3: EXPR_L3 L3 EXPR_L2 | EXPR_L2 ;

EXPR_L2: EXPR_L2 POWER EXPR_L1 | EXPR_L1 ;

EXPR_L1: MACRO | LPAREN EXPR_L4 RPAREN | EXPR_L1 LBRACKET EXPR_L4 RBRACKET | EXPR_L0 ;

EXPR_L0: NUM_INTEGER | NUM_DOUBLE | STR | VAR ;

%%

int yyerror(char *s){
	printf("\nERROR:\n%s\nERROR END\n", s);
	return 1;
}
int main(){
	yyparse();
}
int yywrap(){
	return 1;
}
