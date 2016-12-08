/*************** Optimisation *********************/

//if IDF.used used=1
void used(char name[50]){
    item adress=creat_noeud();
    search(name,&adress);
    adress->content.used = 1;
}

//Just test !!!
/*
void delete(){
    item p;
    int i;

    for(i=0;i<N;i++){
        if(TS[i]!=NULL){
            if(TS[i]->content.used==0){
                TS[i]=NULL;
            }
        }
    }
}
*/

//Delete if IDF not used
void deleteNotUsed(){
    item p,q;
    int i;
    for(i=0;i<N;i++){
        /* Without Colision */ 
        if(TS[i]!=NULL){
            if(TS[i]->content.used==0){
                TS[i]=NULL;
            }else{
        
        /* After Colision */
        p=q=TS[i];
        while(p->svt != NULL){
            if(p->content.used==0){
                q->svt=p->svt;
            }
        q=p;
        p=p->svt;
        }
        }}
    }

}