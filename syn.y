%{
#include <stdio.h>
#include <string.h>
#include "struct.h"
#include "TS.h"
#include "routine.h"
#include "quad.h"
#include "op.h"
extern FILE* yyin;
extern int yylineno;
int yyerror(char *msg);
int ty;
char word[50];
%}
%union{
char *String;
char Car;
int Integer ;
float nbReel;
}

%token VAR CODE INTEGER FLOAT VEC CHAR CONST IF ELSE END WHILE FOR
%token '+' '-' '*' '/' '<' '>' '!' '&' or eg dif infeg supeg
%token '{' '}' '[' ']' ';' ',' '|' '(' ')' '@'
%token <String> IDF 
%token <Integer> Entier
%token <nbReel> Reel 
%token <Car> caractere

%left or
%left and 
%left '!'
%left '>' supeg eg dif infeg '<' 
%left '+' '-'
%left '/' '*'
%left '(' ')'

%%
S : IDF '{' VAR'{' Declarations '}' CODE '{' Instructions '}' '}'
        {printf("\n    *_*  Programme Correct  *_*\n");return 0;}

Type: INTEGER {ty=1;} |CHAR {ty=3;}| FLOAT {ty=2;} 
;
idfVar : IDF {if(!doubleDec($1)) insert($1,ty,0,0);}|
         IDF {if(!doubleDec($1)) insert($1,ty,0,0);} '|' idfVar |
;
idfTabVar : IDF'['Entier']' {
            if(!doubleDec($1)) 
                insert($1,ty,$3,0);
                sprintf(word,"%d",$3);
                quad("BOUNDS","1",word," ");
                quad("ADEC",$1," "," "); 
            }
            |IDF'['Entier']' {
            if(!doubleDec($1)) 
                insert($1,ty,$3,0);
                sprintf(word,"%d",$3);
                quad("BOUNDS","1",word," ");
                quad("ADEC",$1," "," ");
            } '|'idfTabVar
;
Declarations :  Type idfVar ';' Declarations | 
                VEC Type idfTabVar ';' Declarations |
                |CONST IDF '=' typeVal ';' {
                if(!doubleDec($2)) 
                    insert($2,0,0,0);
                } Declarations
;
typeVal : Entier {ty=1;}|caractere {ty=3;}|Reel {ty=2;}
;
Instructions : Affectation|WhileLoop|ifC|ifElse|inst
;
inst :  Affectation Instructions|
    WhileLoop Instructions|
    ifC Instructions|
    ifElse Instructions
;
Affectation :   IDF '=' IDF ';' {
                    checkType(getType($1),getType($3));
                    used($1);
                    used($3);
                    quad("=",$1,$3," ");
                    } |
                IDF '['Entier']' '=' typeVal ';' {
                    checkSize($1,$3); checkType(getType($1),ty);
                    used($1);
                    }|
                IDF '=' typeVal ';' {
                    checkType(getType($1),ty);
                    used($1);
                   /* sprintf(word,"%d",$3);
                    quad("=",$1,word," ");*/
                    }|
                IDF '=' IDF '['Entier']' ';' {
                    checkSize($3,$5);
                    checkType(getType($1),getType($3)); 
                    used($1);
                    used($3);
                    }|
                IDF '[' Entier ']' '=' IDF ';' {
                    checkSize($1,$3); 
                    checkType(getType($1),getType($6));
                    }|
                IDF '='operationArithmetique ';'
;
expAfect : IDF{ used($1); }  | typeVal
;
exp :  IDF { used($1); } | typeVal | operationLogique | operationArithmetique
;
operationArithmetique : 
        expAfect '+' expAfect |
        expAfect '-' expAfect |
        expAfect '*' expAfect |
        expAfect '/' expAfect 
;
operationLogique :  
            exp or exp |
            exp '&' exp|
            exp '!' exp|
                '!''('exp')'
;   
operationComparaison : 
        exp '>' exp |
        exp '<' exp |
        exp dif exp |
        exp eg exp |
        exp supeg exp |
        exp infeg exp 
;
Condition : operationComparaison|operationLogique
;
WhileLoop : WHILE '(' Condition ')' Instructions  END
;
ifC : IF '(' Condition')' Instructions END 
;
ifElse : IF '(' Condition')' Instructions ELSE Instructions END
;


%%
int yyerror(char *msg) {
    printf("----- Error at line: %d ==> %s",yylineno,msg);  
    exit(0);
    return 1;
}

int main()
{ 
    yyin=fopen("code.txt","r");
    init();
    yyparse();
    display();
    displayQ();
    return 0;
}

