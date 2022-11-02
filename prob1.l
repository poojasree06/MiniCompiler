
%{
    #include<stdio.h>
    #include<stdlib.h>
    #include"y.tab.h"

%}

%%
[ \t]|\n ;
"int" {strcpy(yylval.name,yytext);return INT;}
"float" {strcpy(yylval.name,yytext);return FLOAT;}
"double" {strcpy(yylval.name,yytext);return DOUBLE;}
"char" {strcpy(yylval.name,yytext);return CHAR;}
"if"   {strcpy(yylval.name,yytext);return IF;}
"else"   {strcpy(yylval.name,yytext);return ELSE;}
"then"   {strcpy(yylval.name,yytext);return THEN;}
"while" {strcpy(yylval.name,yytext);return WHILE;}
"main"  {strcpy(yylval.name,yytext);return MAIN;}
[0-9]+|[0-9]+[.][0-9]* {strcpy(yylval.name,yytext);return NUM;}
[_a-zA-Z][_a-zA-Z]* {strcpy(yylval.name,yytext);return ID;}
"==" {strcpy(yylval.name,yytext);return EQUAL;}
"++" {strcpy(yylval.name,yytext);return INC;}
"--" {strcpy(yylval.name,yytext);return DEC;}
"!="  {strcpy(yylval.name,yytext);return NOTEQ;}
"<="  {strcpy(yylval.name,yytext);return LTEQ;}
">="  {strcpy(yylval.name,yytext);return GTEQ;}
"||"  {strcpy(yylval.name,yytext);return OR;}
"&&"  {strcpy(yylval.name,yytext);return AND;}
"+="  {strcpy(yylval.name,yytext);return ADDEQ;}
"-="  {strcpy(yylval.name,yytext);return SUBEQ;}
"*="   {strcpy(yylval.name,yytext);return MULEQ;}
"/="   {strcpy(yylval.name,yytext);return DIVEQ;}
"%="   {strcpy(yylval.name,yytext);return MODULOEQ;}
"?" | 
":" |
"=" |
"+" |
"-" |
"*" |
"/" |
"|" |
"(" |
")" |
"{" |
"}" |
"[" |
"]" |
"," |
";" | 
"<" |
">" |
"!"  { return yytext[0]; }
 .  { yyerror ("unexpected character");}


%%


 int yywrap (void) {return 1;}
