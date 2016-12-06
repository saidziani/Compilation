#include <stdio.h>
#include <stdlib.h>
#include <string.h>

    /*=========   Fonctions didiés à la gestion de la table des symboles   =================== */

#define N 1000

//content structure
typedef struct{
    int type;
    int size;
    int constant;
    int used;
    char name[50];
}Content;

//item structure
typedef struct ne * item;
typedef struct ne{
    Content content;
    item svt;
}noeud;

//Quadruplet structure
typedef struct{
    char oper[50];
    char op1[50];
    char op2[50];
    char result[50];
}Quad;

//declaration
item TS[N];
Quad TQ[N];

