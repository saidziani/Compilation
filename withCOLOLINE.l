%{
#include <stdio.h>
#include "syn.tab.h"
extern YYSTYPE yylval ;
%}
%option yylineno

signe[-+]
alpha[a-zA-Z]
minisc[a-z]
majusc[A-Z]
chiffre[0-9]
entier 0|[1-9]{chiffre}*
entier_signe "("{signe}[1-9]{chiffre}*")"
reel chiffre+.chiffre+
reel_signe "("{signe}{reel}")"
caractere \'(.)\'
comment %%(.)
tab [\t]+
idf {majusc}({alpha}|{chiffre})*{0,6}
saut "\n"+

%%

"VAR"       {return VAR;}
"CODE"      {return CODE;}

"INTEGER"   {return INTEGER; }
"FLOAT"     {return FLOAT;}
"CHAR"      {return CHAR;}
"CONST"     {return CONST;}
"VEC"       {return VEC;}

"IF"        {return IF;}
"ELSE"      {return ELSE;}
"END"     {return END;}

"FOR"       {return FOR;}
"WHILE"     {return WHILE;}
" "

{idf}   {yylval.String=strdup(yytext); return IDF;}
{entier}    {yylval.Integer=atoi(yytext); return Entier;}
{entier_signe}  {char *place= yytext+strlen(yytext)-2; yylval.Integer=strtol(yytext+1,&place,10); return Entier;}
{reel}  {return Reel;}
{reel_signe}    {char *place= yytext+strlen(yytext)-2; yylval.nbReel=strtol(yytext+1,&place,10); return Reel;}
{caractere}       {return caractere;}
{comment}


"="     {colo+=yyleng; return '=';}       
"+"     {return '+';}
"-"     {return '-';}
"*"     {return '*';}
"/"     {return '/';} 
">"     {return '>';}
"<"     {return '<';}
"=="    {return eg;}
"!="    {return dif;}
"<="    {return infeg;}
">="    {return supeg;}
"&"    {return '&';}
"||"    {return or;}
"!"     {return '!';}
"{"     {return '{';}
"}"     {return '}';}
";"     {return ';';}
","     {return ',';}
"["     {return '[';}
"]"     {return ']';}
")"     {return ')';}
"("     {return '(';}
"|"     {return '|';}
"@"     {return '@';}

{tab}
{saut} {colo=1;line+=yleng;}
"\n"     
.    {ECHO ; printf("Erreur\n");}

%%

int yywrap(){
    return 1;
}



