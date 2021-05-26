%{
    #include "config1.h"
#include "y.tab.h"
#include <stdio.h>  
#include <stdlib.h>
#include <cmath>
#include <cstring>
#include <ctype.h>
void yyerror (char *s);
int yylex();



%}
%option noyywrap
%%

"int" {return INT;}
"float" {return FLOAT;}
"char" {return CHAR;}
"string" {return STRING;}
"bool" {return BOOL;}


"+" {return plus;}
"-" {return minus;}
"*" {return multiply;}
"/" {return divide;}
"^" {return power;}
"%" {return modulo;}

"print"         {return print;}
"end"           {return end_progr;}
"main:"         {return main_progr;}
"if"            {return IF;}
"else"          {return ELSE;}
"while"         {return WHILE;}
"for"           {return FOR;}
"class"         {return CLASS;}
"function"      {return FUNCTION;}
"tabel_valori"  {return TV;}
"const"         {return CONSTANTa;}


"<"         {return mai_mic;}
">"         {return mai_mare;}
"<="        {return mai_mic_egal;}
">="        {return mai_mare_egal;}
"=="        {return egalitate;}
"!="        {return diferit;}
"&&"|"and"  {return AND;}
"||"|"or"   {return OR;}



"false"|"true"                  {yylval.ex.b_slot=strdup(yytext); yylval.ex.t_slot=strdup("bool"); return BOOL;}
[a-zA-Z][a-zA-Z0-9]*            {yylval.ex.nume = strdup(yytext);  return ID;}
-?([1-9][0-9]*|0)               {yylval.ex.i_slot=atoi(yytext); yylval.ex.t_slot=strdup("int"); return INT;}
-?([1-9][0-9]*|0)\.([0-9]*)     {yylval.ex.f_slot=atof(yytext); yylval.ex.t_slot = strdup("float"); return FLOAT;}
\'[^ \']\'                      {yylval.ex.c_slot=yytext[1]; yylval.ex.t_slot = strdup("char"); return CHAR;}
\"[^ \"]*\"                     {char* temp = strdup(yytext); temp[strlen(temp)-1]=NULL; int lg=strlen(temp); for(int i=0; i<=lg-2; i++) temp[i]=temp[i+1]; temp[lg-1]=NULL; yylval.ex.s_slot=strdup(temp); yylval.ex.t_slot = strdup("string");  return STRING;}
"//"[^\n\r]* ; 
[ \t\r] ;
\n {yylineno++;}
. {return yytext[0];}

%%
