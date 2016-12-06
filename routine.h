
/************************* Routine ***********************/

//Double declaration
int doubleDec(char name[]){
    item ad=creat_noeud();
    if(search(name,&ad)) {
        yyerror("IDF already declared");
        return 1;
    }
    return 0;
}

//get size of items
int getSize(char name[]){
    item adress=creat_noeud();
    search(name,&adress);
    //printf("%s/%d/%d\n",adress->content.name,adress->content.type,adress->content.size );
    return adress->content.size ;
}

//check size
int checkSize(char name[],int size){
    if(getSize(name)<size){
        yyerror("Table Size Over Flow");
        return 0;
    }
    return 1;
}

//get type of items
int getType(char name[]){
    item adress=creat_noeud();
    search(name,&adress);
    return adress->content.type ;
}

//check type
int checkType(int type1,int type2){
    if( type1 != type2 ){
        //printf("%d != %d\n",type1, type2 );
        yyerror("Types Incompatibility");
        return 0;
    }
    return 1;
}


//get if CONST
int getConst(char name[]){
    item adress=creat_noeud();
    search(name,&adress);
    return adress->content.constant ;
}

//check if CONST 
int checkConstModif(char name[]){
    if( getConst(name) ){
        yyerror("Constant can't be modified !");
        return 0;
    }
    return 1;
}

