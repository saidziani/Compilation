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
idfVar : IDF {if(!doubleDec($1)) insert($1,ty,0,-1,0);}|
         IDF {if(!doubleDec($1)) insert($1,ty,0,-1,0);} '|' idfVar |
;
idfTabVar : IDF'['Entier']' {
            if(!doubleDec($1)) 
                insert($1,ty,0,$3,0);
                sprintf(word,"%d",$3);
                quad("BOUNDS","1",word," ");
                quad("ADEC",$1," "," "); 
            }
            |IDF'['Entier']' {
            if(!doubleDec($1)) 
                insert($1,ty,0,$3,0);
                sprintf(word,"%d",$3);
                quad("BOUNDS","1",word," ");
                quad("ADEC",$1," "," ");
            } '|'idfTabVar
;
Declarations :  Type idfVar ';' Declarations | 
                VEC Type idfTabVar ';' Declarations |
                |CONST IDF '=' typeVal ';' {
                if(!doubleDec($2))
                    insert($2,ty,1,-1,0);
                } Declarations
;
typeVal : Entier {ty=1;}|caractere {ty=3;}|Reel {ty=2;}
;
Instructions : Affectation|WhileLoop|ForLoop|ifC|ifElse|inst
;
inst :  Affectation Instructions|
    ForLoop Instructions|
    WhileLoop Instructions|
    ifC Instructions|
    ifElse Instructions
;
Affectation :   IDF '=' IDF ';' {
                    checkConstModif($1);
                    checkType(getType($1),getType($3));
                    used($1);
                    used($3);
                    quad("=",$1,$3," ");
                    } |
                IDF '['Entier']' '=' typeVal ';' {
                    checkConstModif($1);
                    checkSize($1,$3); checkType(getType($1),ty);
                    used($1);
                    }|
                IDF '=' typeVal ';' {
                    checkConstModif($1);
                    checkType(getType($1),ty);
                    used($1);
                    }|
                IDF '=' IDF '['Entier']' ';' {
                    checkConstModif($1);
                    checkSize($3,$5);
                    checkType(getType($1),getType($3)); 
                    used($1);
                    used($3);
                    }|
                IDF '[' Entier ']' '=' IDF ';' {
                    checkSize($1,$3); 
                    checkType(getType($1),getType($6));
                    used($1);
                    used($6);
                    }|
                IDF '[' IDF ']' '=' IDF ';' {
                    checkType(getType($1),getType($6));
                    getArit(getType($3));
                    used($1);
                    used($3);
                    used($6);
                    }|
                IDF '[' IDF ']' '=' typeVal ';' {
                    checkType(getType($1),ty);
                    getArit(getType($3));
                    used($1);
                    used($3);
                    }|
                IDF '=' IDF '[' IDF ']' ';' {
                    checkConstModif($1);
                    checkType(getType($1),getType($3));
                    getArit(getType($5));
                    used($1);
                    used($3);
                    used($5);
                    }|
                IDF '='operationArithmetique ';'{
                    getArit(getType($1));
                    checkConstModif($1);
                    used($1);
                    }|
                IDF '[' Entier ']' '='operationArithmetique ';'{
                    checkConstModif($1);
                    getArit(getType($1));
                    used($1);
                    }|
                IDF '[' IDF ']' '='operationArithmetique ';'{
                    checkConstModif($1);
                    getArit(getType($1));
                    getArit(getType($3));
                    used($1);
                    used($3);
                    }
;
expArit : IDF{ used($1); getArit(getType($1)); }  |
          IDF '['Entier']' { used($1); getArit(getType($1)); }  |
          IDF '['IDF']' { used($1); used($3); getArit(getType($1)); getArit(getType($3)); }  |
          typeVal { getArit(ty); }
;
exp :  IDF { used($1); } | 
       IDF '['Entier']' { used($1); getArit(getType($1)); }  |
       IDF '['IDF']' { used($1); used($3); getArit(getType($1)); getArit(getType($3)); }  |
       typeVal | operationLogique | operationArithmetique
;
expCompar :  IDF { used($1); getArit(getType($1)); } | 
             IDF '['Entier']' { used($1); getArit(getType($1)); }  |
             IDF '['IDF']' { used($1); used($3); getArit(getType($1)); getArit(getType($3)); }  |
             typeVal {getArit(ty);} | operationArithmetique
;
operationArithmetique : 
        expArit'+'expArit |
        expArit'-'expArit |
        expArit'*'expArit |
        expArit'/'expArit 
;
operationLogique :  
            exp or exp |
            exp '&' exp|
            exp '!' exp|
                '!''('exp')'
;   
operationComparaison : 
        expCompar '>' expCompar |
        expCompar '<' expCompar |
        expCompar dif expCompar |
        expCompar eg expCompar |
        expCompar supeg expCompar |
        expCompar infeg expCompar 
;
Condition : operationComparaison|operationLogique
;
WhileLoop : WHILE '(' Condition ')' Instructions  END
;
ForLoop : FOR '('IDF':' Entier':' IDF ')' Instructions END
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
    deleteNotUsed();
    displayQ();
    //display();
    return 0;
}

