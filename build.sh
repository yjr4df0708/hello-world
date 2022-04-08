#!/bin/bash
# There is definitely a better way to do this.
if [[ -z "$1" ]]; then
	lex="interpreter.l";
else
	lex="$1";
fi
if [[ -z "$2" ]]; then
	yacc="interpreter.y";
else
	yacc="$2";
fi
if [[ -z "$3" ]]; then
	out="interpreter";
else
	out="$3";
fi
flex $lex
bison $yacc
gcc -o $out lex.yy.c
chmod +x $out
