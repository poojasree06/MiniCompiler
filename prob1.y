%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

void genCode(char a[],char b[],char op[],char res[]);
void genAssignCode(char a[],char b[],char res[]);
void genUnaryCode(char a[],char op[],char res[]);
int yyerror(char* s);

char TAC[100][30];
char string[100];
char l[5]="L";
char t[5]="t";
int temp=0;
int label=0;
int line=0;

%}

%union{
    char name[10];
}

%type <name> L factor relOp assignOp SuffixExpr PrefixExpr term expr relExpr eqExpr andExpr simpleExpr assignExpr

%token <name>  ID NUM IF ELSE THEN  WHILE INT CHAR FLOAT DOUBLE MAIN OR AND LTEQ GTEQ NOTEQ EQUAL

%token <name> ADDEQ SUBEQ MULEQ DIVEQ MODULOEQ INC DEC



%%
program : blocks {printf(" done\n");};

blocks : blocks block | block ;

block : '{' block_inside '}'  ;

block_inside : declarations stmtlist ;

declarations : declarations decl | {/**/} ;

decl : typelist varlist ';' ;

varlist : varlist ',' var  ;

varlist : var ;

var : L '=' var ;

var : expr ;

stmtlist :  stmt stmtlist| {/**/} ;  

stmt : assignExpr | selectExpr | iterExpr ;

selectExpr : IF '(' simpleExpr ')' block ;

selectExpr : IF '(' simpleExpr ')' block ELSE block ;

iterExpr : WHILE  '(' simpleExpr ')' block ;

assignExpr : L assignOp assignExpr      {genAssignCode($1,$3,$$);};

assignExpr : simpleExpr ';' ;

simpleExpr : simpleExpr OR andExpr 	{genCode($1,$3,"||",$$);};

simpleExpr : andExpr ;	     

andExpr : andExpr AND eqExpr         	{genCode($1,$3,"&&",$$);};

andExpr : eqExpr ;

eqExpr : eqExpr EQUAL relExpr       	{genCode($1,$3,"==",$$);};

eqExpr : eqExpr NOTEQ relExpr 	    	{genCode($1,$3,"!=",$$);};

eqExpr : relExpr ;

relExpr : relExpr relOp expr        	{genCode($1,$3,$2,$$);};

relExpr : expr ;

expr : expr '+' term 			{genCode($1,$3,"+",$$);};

expr : expr '-' term 			{genCode($1,$3,"-",$$);};

expr : term 

term : term '*' PrefixExpr 		{genCode($1,$3,"*",$$);};

term : term '/' PrefixExpr 		{genCode($1,$3,"/",$$);};

term : term '%' PrefixExpr 		{genCode($1,$3,"%",$$);};

term :  PrefixExpr 

PrefixExpr : '+' PrefixExpr             {genUnaryCode($2,"+",$$);};

PrefixExpr : '-' PrefixExpr  		{genUnaryCode($2,"-",$$);};

PrefixExpr : INC PrefixExpr 	        {
					    char text[10];
					    sprintf(text, "%d", temp++); 
					    strcat(t,text);  
					    strcpy(string,t);
					    strcat(string,"=");
					    strcat(string,$2);
					    strcat(string,"+");
					    strcat(string,1);
					    strcpy(t,"t");
					    genCode($2,"1","++",$$);};	

PrefixExpr : DEC PrefixExpr 		

PrefixExpr : SuffixExpr ;

SuffixExpr : SuffixExpr INC ;

SuffixExpr : SuffixExpr DEC ;

SuffixExpr : factor;

assignOp : '='  {strcpy($$,"=");} | MULEQ | ADDEQ | SUBEQ | DIVEQ | MODULOEQ ;

relOp : '<' {strcpy($$,"<");} | '>' {strcpy($$,">");} | LTEQ | GTEQ ;

typelist : INT | FLOAT | CHAR | DOUBLE; 

factor : ID 

factor : NUM 

factor : '(' expr ')'   {strcpy($$,$2);};

L : ID 			{strcpy($$,$1);};

%% 

void genAssignCode(char a[],char b[],char res[]){
    strcpy(string,a);
    strcpy(res,string);                   
    strcat(string,"=");
    strcat(string,b);
    strcpy(TAC[line++],string);
    strcpy(t,"t");
    printf(" %s\n",string);
     
}


void genCode(char a[],char b[],char op[],char res[]){
    char text[10];
    sprintf(text, "%d", temp++);   	// text="1" 
    strcat(t,text);                	// t=t+"1" =t1
    strcpy(res,t);  			// generarting temp variable Ex - t1
    strcpy(string,res);  
    strcat(string,"=");
    strcat(string,a);
    strcat(string,op);
    strcat(string,b);
    strcpy(TAC[line++],string);
    strcpy(t,"t");
    printf(" %s\n",string);
     
}

void genUnaryCode(char a[],char op[],char res[]){
    char text[10];
    sprintf(text, "%d", temp++); 
    strcat(t,text);                	
    strcpy(res,t);  			
    strcpy(string,res);  
    strcat(string,"=");
    strcat(string,op);
    strcat(string,a);
    strcpy(TAC[line++],string);
    strcpy(t,"t");
    printf(" %s\n",string);
}

int yyerror(char *s){
  printf("\n\n Syntax error\n");
  return 0;
}

extern FILE * yyin;

int main(int argc, char* argv[])
{
	if(argc > 1)
	{
		FILE *fp = fopen(argv[1], "r");
		if(fp)
			yyin = fp;
	}
	yyparse();      

	return 0;
}
