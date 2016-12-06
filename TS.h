
/**************** Table des symboles *********************/

//initialisation 
void init(){
    int i;
    for(i=0;i<N;i++){
        TS[i]=NULL ;
    
}}

//Allocation
item creat_noeud(){
    item p;
    p=(item)malloc(sizeof(noeud));
    if (p==NULL)
    {
        printf("Erreur !");
        exit(-1);
    }
    return(p);
}

//hash function
int hash(char mot[]){
    unsigned int cpt , add = 0;
    for(cpt=0;mot[cpt]!='\0';cpt++){
        add = add*mot[cpt] + mot[cpt] + cpt ;
    }
    return (add);
}

//search
int search(char name[],item *adress){
 
    int i= hash(name) % N,b=0;
    item p=creat_noeud();
    p=TS[i];
    *adress=p;
    if( p == NULL ){
        return 0;
    }
    if(!strcmp(p->content.name,name)){
        return 1;
    }
    p=p->svt;
    while( (p != NULL) && strcmp(p->content.name,name) ){ 
        p=p->svt;
        *adress=p;
    }

    if( p == NULL ) return 0 ;

    return 1;
}

//insertion
int insert(char name[],int type,int constant,int size,int used){
    item p=creat_noeud(),adr=creat_noeud();
    int i=hash(name)%N;

    p->content.type= type;
    p->content.constant= constant;
    p->content.size= size;
    p->content.used= used;
    strcpy(p->content.name,name);
    
    if(!search(name,&adr)){
    if(TS[i]==NULL){
        p->svt=NULL;
        TS[i]=p;
    }
    else{
        p->svt=TS[i];
        TS[i]=p;
    }
    } 
}

//display
void display(){
    item p;
    int i;

    printf("\n________________________________________");
    printf("\n          Table des Symboles            |");
    printf("\n________________________________________|");
    printf("\nINDICE|NAME-IDF |SIZE |  TYPE   | CONST |");
    printf("\n______|_________|_____|_________|_______|\n");

    for(i=0;i<N;i++){
        if(TS[i]!=NULL){
        printf("%.4d  |",i);
        printf("[%s]\t",TS[i]->content.name);
        if(TS[i]->content.size == (-1)){
            printf("|%.4d|",TS[i]->content.size);
        }else{
            printf("|%.5d|",TS[i]->content.size);
        }
        
        switch(TS[i]->content.type)
        {
        case 1:printf("\tINTEGER\t|\n"); break;
        case 2:printf("\tFLOAT\t|\n");break;
        case 3:printf("\tCHAR\t|\n");break;
        case 0:printf("\tCONST\t|\n");break;
        }
        if(!TS[i]->content.constant{
            printf("  NO   ");
        }else{
            printf("  YES  ");
        }
        /* Before Colision */
        p=TS[i];
        while(p->svt != NULL){
        printf("%.4d  |",i);
        printf("[%s]\t",p->content.name);
        if(p->content.size ==(-1)){
            printf("|%.4d|",p->content.size);
        }else{
            printf("|%.5d|",p->content.size);
        }
        switch(p->content.type)
        {
        case 1:printf("\tINTEGER\t|\n"); break;
        case 2:printf("\tFLOAT\t|\n");break;
        case 3:printf("\tCHAR\t|\n");break;
        case 0:printf("\tCONST\t|\n");break;
        }
        p=p->svt;
        }
        }
    }
    printf("______|_________|_____|_________|_______|\n\n");

}





