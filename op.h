/*************** Optimisation *********************/

//if IDF.used used=1
void used(char name[50]){
    item adress=creat_noeud();
    search(name,&adress);
    adress->content.used = 1;
}

void deleteNotUsed(){
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