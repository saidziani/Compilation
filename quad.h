
/**************** Table des quadruplets *********************/
int indexQ=0 ;

void quad(char oper[50], char op1[50], char op2[50], char res[50]){
    Quad q;
    strcpy(q.oper,oper);
    strcpy(q.op1,op1);
    strcpy(q.op2,op2);
    strcpy(q.result,res);

    TQ[indexQ]=q;
    indexQ++;
}


//display
void displayQ(){
    int i;

    printf("\n________________________________");
    printf("\n           Quadruplets          |\n");
    puts("\n");

    for(i=0;i<indexQ;i++){
            printf("(%s,%s,%s,%s)\n",TQ[i].oper,TQ[i].op1,TQ[i].op2,TQ[i].result);
    }

}
