%{
void yyerror (char *s);
int yylex(void);


#include "config1.h" 

#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
#include <ctype.h>
#include <math.h>
#include <vector>
#include <cstring>
#include <string>
#include <iostream>
#include <fstream>

extern FILE * yyin;

#define MAX_SIZE 1024

using namespace std;

vector<date_info> lista_variabile;

int sscope=0;
int nr_functii=1;

 void printeaza_tabel()
 {
    ofstream f_out("tabel_variabile.txt");
    for(int i=0; i<lista_variabile.size();i++)
    {
        f_out << lista_variabile[i].t_slot << " --- " << lista_variabile[i].nume << " --- " ;
        if(strcmp(lista_variabile[i].t_slot,"int")==0)
            f_out << lista_variabile[i].i_slot << " --- " ;
        if(strcmp(lista_variabile[i].t_slot,"float")==0)
            f_out << lista_variabile[i].f_slot << " --- " ;
        if(strcmp(lista_variabile[i].t_slot,"string")==0)
            f_out << lista_variabile[i].s_slot << " --- " ;
        if(strcmp(lista_variabile[i].t_slot,"bool")==0)
            f_out << lista_variabile[i].b_slot << " --- " ;
        if(strcmp(lista_variabile[i].t_slot,"char")==0)
            f_out << lista_variabile[i].c_slot << " --- " ;
        f_out << lista_variabile[i].scope << endl;
    }

 }

void adauga_variabila_test()
{
    date_info variabila_test;
    variabila_test.nume = strdup("aaa");
    variabila_test.scope = 1;
    lista_variabile.push_back(variabila_test);
}

void printeaza(date_info* variabila)
{
    if(strcmp(variabila->t_slot,"int")==0) {printf("%d\n",variabila->i_slot); return;}
    if(strcmp(variabila->t_slot,"float")==0) {printf("%f\n",variabila->f_slot); return;}
    if(strcmp(variabila->t_slot,"bool")==0) {printf("%s\n",variabila->b_slot); return;}
    if(strcmp(variabila->t_slot,"char")==0) {printf("%c\n",variabila->c_slot); return;}
    if(strcmp(variabila->t_slot,"string")==0) {printf("%s\n",variabila->s_slot); return;}
    printf("\n eroare!!\n");
}

date_info exp_add(date_info* v1, date_info* v2)
{
    date_info aux;
    if(strcmp(v1->t_slot,"bool")==0 || strcmp(v2->t_slot,"bool")==0)
    {
        aux.t_slot = strdup("eroare");
        return aux;
    }

    if(strcmp(v1->t_slot,"int")==0)
    {
        if(strcmp(v2->t_slot,"string")==0 || strcmp(v2->t_slot,"bool")==0)
        {
            aux.t_slot = strdup("eroare");
            return aux;
        }
        if(strcmp(v2->t_slot,"int")==0)
        {
            aux.t_slot = strdup("int");
            aux.i_slot = v1->i_slot + v2->i_slot;
            return aux;
        }
        if(strcmp(v2->t_slot,"float")==0)
        {
            aux.t_slot = strdup("float");
            aux.f_slot = v1->i_slot + v2->f_slot;
            return aux;
        }
        if(strcmp(v2->t_slot,"char")==0)
        {
            aux.t_slot = strdup("char");
            aux.c_slot = v1->i_slot + v2->c_slot;
            return aux;
        }
    }
    if(strcmp(v1->t_slot,"float")==0)
    {
        if(strcmp(v2->t_slot,"string")==0 || strcmp(v2->t_slot,"bool")==0 || strcmp(v2->t_slot,"char")==0)
        {
            aux.t_slot = strdup("eroare");
            return aux;
        }
        if(strcmp(v2->t_slot,"int")==0)
        {
            aux.t_slot = strdup("float");
            aux.f_slot = v1->f_slot + v2->i_slot;
            return aux;
        }
        if(strcmp(v2->t_slot,"float")==0)
        {
            aux.t_slot = strdup("float");
            aux.f_slot = v1->f_slot + v2->f_slot;
            return aux;
        }
    }
    if(strcmp(v1->t_slot,"char")==0)
    {
        if(strcmp(v2->t_slot,"float")==0 || strcmp(v2->t_slot,"bool")==0)
        {
            aux.t_slot = strdup("eroare");
            return aux;
        }
        if(strcmp(v2->t_slot,"int")==0)
        {
            aux.t_slot = strdup("char");
            aux.c_slot = v1->c_slot + v2->i_slot;
            return aux;
        }
        if(strcmp(v2->t_slot,"string")==0)
        {
            aux.t_slot = strdup("string");
            char* temp = new char[100]; temp[0]=v1->c_slot; strcat(temp,v2->s_slot); 
            aux.s_slot=strdup(temp);
            return aux;                                     
        }
        if(strcmp(v2->t_slot,"char")==0)
        {
            aux.t_slot = strdup("char");
            aux.c_slot = v1->c_slot + v2->c_slot;
            return aux;
        }
    }
    if(strcmp(v1->t_slot,"string")==0)
    {
        if(strcmp(v2->t_slot,"float")==0 || strcmp(v2->t_slot,"bool")==0 || strcmp(v2->t_slot,"int")==0)
        {
            aux.t_slot = strdup("eroare");
            return aux;
        }
        if(strcmp(v2->t_slot,"string")==0)
        {
            aux.t_slot = strdup("string");
            char* temp = strdup(v1->s_slot); strcat(temp,v2->s_slot);
            aux.s_slot=strdup(temp);        
            return aux;                                     
        }
        if(strcmp(v2->t_slot,"char")==0)
        {
            aux.t_slot = strdup("string");
            char* temp = strdup(v1->s_slot); temp[strlen(temp)]=v2->c_slot;
            temp[strlen(temp)+1]=NULL; aux.s_slot=strdup(temp);
            return aux;
        }
    }
}

date_info exp_mul(date_info* v1, date_info* v2)
{
    date_info aux;
    if(strcmp(v1->t_slot,"bool")==0 || strcmp(v2->t_slot,"bool")==0 || strcmp(v1->t_slot,"string")==0 || strcmp(v2->t_slot,"string")==0 )
    {
        aux.t_slot = strdup("eroare");
        return aux;
    }

    if(strcmp(v1->t_slot,"int")==0)
    {
        if(strcmp(v2->t_slot,"int")==0)
        {
            aux.t_slot = strdup("int");
            aux.i_slot = v1->i_slot * v2->i_slot;
            return aux;
        }
        if(strcmp(v2->t_slot,"float")==0)
        {
            aux.t_slot = strdup("float");
            aux.f_slot = v1->i_slot * v2->f_slot;
            return aux;
        }
        if(strcmp(v2->t_slot,"char")==0)
        {
            aux.t_slot = strdup("char");
            aux.c_slot = v1->i_slot * v2->c_slot;
            return aux;
        }
    }
    if(strcmp(v1->t_slot,"float")==0)
    {
        if(strcmp(v2->t_slot,"char") == 0)
        {
            aux.t_slot = strdup("eroare");
            return aux;
        }
        if(strcmp(v2->t_slot,"int")==0)
        {
            aux.t_slot = strdup("float");
            aux.f_slot = v1->f_slot * v2->i_slot;
            return aux;
        }
        if(strcmp(v2->t_slot,"float")==0)
        {
            aux.t_slot = strdup("float");
            aux.f_slot = v1->f_slot * v2->f_slot;
            return aux;
        }
    }
    if(strcmp(v1->t_slot,"char")==0)
    {
        if(strcmp(v2->t_slot,"float")==0)
        {
            aux.t_slot = strdup("eroare");
            return aux;
        }
        if(strcmp(v2->t_slot,"int")==0)
        {
            aux.t_slot = strdup("char");
            aux.c_slot = v1->c_slot * v2->i_slot;
            return aux;
        }
        if(strcmp(v2->t_slot,"char")==0)
        {
            aux.t_slot = strdup("char");
            aux.c_slot = v1->c_slot * v2->c_slot;
            return aux;
        }
    }
    }

date_info exp_div(date_info* v1, date_info* v2)
{
    date_info aux;
    if(strcmp(v1->t_slot,"bool")==0 || strcmp(v2->t_slot,"bool")==0 || strcmp(v1->t_slot,"string")==0 || strcmp(v2->t_slot,"string")==0 )
    {
        aux.t_slot = strdup("eroare");
        return aux;
    }

    if(strcmp(v1->t_slot,"int")==0)
    {
        if(strcmp(v2->t_slot,"int")==0)
        {
            if(v2->i_slot==0)
            {
                aux.t_slot = strdup("eroare");
                return aux;
            }
            aux.t_slot = strdup("int");
            aux.i_slot = v1->i_slot / v2->i_slot;
            return aux;
        }
        if(strcmp(v2->t_slot,"float")==0)
        {
            if(v2->f_slot==.0f)
            {
                aux.t_slot = strdup("eroare");
                return aux;
            }
            aux.t_slot = strdup("float");
            aux.f_slot = v1->i_slot / v2->f_slot;
            return aux;
        }
        if(strcmp(v2->t_slot,"char")==0)
        {
            if(v2->c_slot==0)
            {
                aux.t_slot = strdup("eroare");
                return aux;
            }
            aux.t_slot = strdup("char");
            aux.c_slot = v1->i_slot / v2->c_slot;
            return aux;
        }
    }
    if(strcmp(v1->t_slot,"float")==0)
    {
        if(strcmp(v2->t_slot,"char") == 0)
        {
            aux.t_slot = strdup("eroare");
            return aux;
        }
        if(strcmp(v2->t_slot,"int")==0)
        {
            if(v2->i_slot==0)
            {
                aux.t_slot = strdup("eroare");
                return aux;
            }
            aux.t_slot = strdup("float");
            aux.f_slot = v1->f_slot / v2->i_slot;
            return aux;
        }
        if(strcmp(v2->t_slot,"float")==0)
        {
            if(v2->f_slot==.0f)
            {
                aux.t_slot = strdup("eroare");
                return aux;
            }
            aux.t_slot = strdup("float");
            aux.f_slot = v1->f_slot / v2->f_slot;
            return aux;
        }
    }
    if(strcmp(v1->t_slot,"char")==0)
    {
        if(strcmp(v2->t_slot,"float")==0)
        {
            aux.t_slot = strdup("eroare");
            return aux;
        }
        if(strcmp(v2->t_slot,"int")==0)
        {
            if(v2->i_slot==0)
            {
                aux.t_slot = strdup("eroare");
                return aux;
            }
            aux.t_slot = strdup("char");
            aux.c_slot = v1->c_slot / v2->i_slot;
            return aux;
        }
        if(strcmp(v2->t_slot,"char")==0)
        {
            if(v2->c_slot==0)
            {
                aux.t_slot = strdup("eroare");
                return aux;
            }
            aux.t_slot = strdup("char");
            aux.c_slot = v1->c_slot / v2->c_slot;
            return aux;
        }
    }
}

date_info exp_mod(date_info* v1, date_info* v2)
{
    date_info aux;
    if(strcmp(v1->t_slot,"int") !=0 || strcmp(v2->t_slot,"int") !=0 )
    {
        aux.t_slot = strdup("eroare");
        return aux;
    }
    aux.t_slot = strdup("int");
    aux.i_slot = v1->i_slot % v2->i_slot;
    return aux;
}

date_info exp_pow(date_info* v1, date_info* v2)
{
    date_info aux;
    if(strcmp(v1->t_slot,"bool") == 0 || strcmp(v2->t_slot,"bool") ==0 || strcmp(v1->t_slot,"char") == 0 || strcmp(v2->t_slot,"char") ==0 || strcmp(v1->t_slot,"string") == 0 || strcmp(v2->t_slot,"string") ==0 )
    {
        aux.t_slot = strdup("eroare");
        return aux;
    }
    if(strcmp(v1->t_slot,"int") == 0 )
    {
        if(strcmp(v2->t_slot,"int") ==0 )
        {
            aux.t_slot = strdup("int");
            aux.i_slot = pow(v1->i_slot,v2->i_slot);
            return aux;
        }
        if(strcmp(v2->t_slot,"float") ==0 )
        {
            aux.t_slot = strdup("float");
            aux.f_slot = pow(v1->i_slot,v2->f_slot);
            return aux;
        }
        
    }
    if(strcmp(v1->t_slot,"float") == 0 )
    {
        if(strcmp(v2->t_slot,"int") ==0 )
        {
            aux.t_slot = strdup("float");
            aux.f_slot = pow(v1->f_slot,v2->i_slot);
            return aux;
        }
        if(strcmp(v2->t_slot,"float") ==0 )
        {
            aux.t_slot = strdup("float");
            aux.f_slot = pow(v1->f_slot,v2->f_slot);
            return aux;
        }
        
    }
    
}

date_info exp_sub(date_info* v1, date_info* v2)
{
    date_info aux;
    if(strcmp(v1->t_slot,"bool")==0 || strcmp(v2->t_slot,"bool")==0)
    {
        aux.t_slot = strdup("eroare");
        return aux;
    }

    if(strcmp(v1->t_slot,"int")==0)
    {
        if(strcmp(v2->t_slot,"string")==0 || strcmp(v2->t_slot,"bool")==0)
        {
            aux.t_slot = strdup("eroare");
            return aux;
        }
        if(strcmp(v2->t_slot,"int")==0)
        {
            aux.t_slot = strdup("int");
            aux.i_slot = v1->i_slot - v2->i_slot;
            return aux;
        }
        if(strcmp(v2->t_slot,"float")==0)
        {
            aux.t_slot = strdup("float");
            aux.f_slot = v1->i_slot - v2->f_slot;
            return aux;
        }
        if(strcmp(v2->t_slot,"char")==0)
        {
            aux.t_slot = strdup("char");
            aux.c_slot = v1->i_slot - v2->c_slot;
            return aux;
        }
    }
    if(strcmp(v1->t_slot,"float")==0)
    {
        if(strcmp(v2->t_slot,"string")==0 || strcmp(v2->t_slot,"bool")==0 || strcmp(v2->t_slot,"char")==0)
        {
            aux.t_slot = strdup("eroare");
            return aux;
        }
        if(strcmp(v2->t_slot,"int")==0)
        {
            aux.t_slot = strdup("float");
            aux.f_slot = v1->f_slot - v2->i_slot;
            return aux;
        }
        if(strcmp(v2->t_slot,"float")==0)
        {
            aux.t_slot = strdup("float");
            aux.f_slot = v1->f_slot - v2->f_slot;
            return aux;
        }
    }
    if(strcmp(v1->t_slot,"char")==0)
    {
        if(strcmp(v2->t_slot,"float")==0 || strcmp(v2->t_slot,"bool")==0)
        {
            aux.t_slot = strdup("eroare");
            return aux;
        }
        if(strcmp(v2->t_slot,"int")==0)
        {
            aux.t_slot = strdup("char");
            aux.c_slot = v1->c_slot - v2->i_slot;
            return aux;
        }
        if(strcmp(v2->t_slot,"string")==0)
        {
            aux.t_slot = strdup("string");
            char* temp = new char[100]; temp[0]=v1->c_slot; strcat(temp,v2->s_slot); 
            aux.s_slot=strdup(temp);
            return aux;                                     
        }
        if(strcmp(v2->t_slot,"char")==0)
        {
            aux.t_slot = strdup("char");
            aux.c_slot = v1->c_slot - v2->c_slot;
            return aux;
        }
    }
    if(strcmp(v1->t_slot,"string")==0)
    {
        if(strcmp(v2->t_slot,"float")==0 || strcmp(v2->t_slot,"bool")==0 || strcmp(v2->t_slot,"int")==0)
        {
            aux.t_slot = strdup("eroare");
            return aux;
        }
        if(strcmp(v2->t_slot,"string")==0)
        {
            aux.t_slot = strdup("string");
            char* p; char* temp = strdup(v1->s_slot);
            p=strstr(temp,v2->s_slot);
            while(p !=NULL) {strcpy(p,p+strlen(v2->s_slot)); p=strstr(p,v2->s_slot);}
            aux.s_slot=strdup(temp);      
            return aux;                                     
        }
        if(strcmp(v2->t_slot,"char")==0)
        {
            aux.t_slot = strdup("string");
            char* p; char* temp = strdup(v1->s_slot);
            p=strchr(temp,v2->c_slot);
            while(p !=NULL) {strcpy(p,p+1); p=strchr(p,v2->c_slot);}
            aux.s_slot=strdup(temp);                                        
            return aux;
        }
    }
}

bool exist_p(date_info* v)
{
    vector<date_info>::iterator it;
    for(it=lista_variabile.begin(); it!=lista_variabile.end(); ++it)
    {
        if(strcmp(v->nume,(it)->nume)==0)
            {
                if(v->scope == (it)->scope)
                    return 1;
            }
    }
    return 0;
}

void rezerva_nume(date_info* v)
{
    date_info aux;
    aux.nume = strdup(v->nume);
    aux.t_slot = strdup(v->t_slot);
    aux.scope = v->scope;
    lista_variabile.push_back(aux);
}

void rezerva_nume_valoare(date_info* v1, date_info* v2)
{
    date_info aux;
    aux.nume = strdup(v1->nume);
    aux.t_slot = strdup(v1->t_slot);
    aux.scope = v1->scope;

    if(strcmp(aux.t_slot,"int")==0)
    {
        if(strcmp(v2->t_slot,"int")==0)
        {
            aux.i_slot = (int)(v2->i_slot);
        }
        if(strcmp(v2->t_slot,"float")==0)
        {
            aux.i_slot = (int)(v2->f_slot);
        }
        if(strcmp(v2->t_slot,"char")==0)
        {
            int aux_i = v2->c_slot - '0';
            aux.i_slot = aux_i;
        }
        if(strcmp(v2->t_slot,"string")==0 || strcmp(v2->t_slot,"bool")==0 )
        {
            aux.nume = strdup("eroare");
        }
    }
    if(strcmp(aux.t_slot,"float")==0)
    {
        if(strcmp(v2->t_slot,"int")==0)
        {
            aux.f_slot = (float)(v2->i_slot);
        }
        if(strcmp(v2->t_slot,"float")==0)
        {
            aux.f_slot = (float)(v2->f_slot);
        }
        if(strcmp(v2->t_slot,"string")==0 || strcmp(v2->t_slot,"char")==0 || strcmp(v2->t_slot,"bool")==0)
        {
            aux.nume = strdup("eroare");
        }
    }
    if(strcmp(aux.t_slot,"char")==0)
    {
        if(strcmp(v2->t_slot,"int")==0)
        {
            aux.c_slot = (char)(v2->i_slot + '0');
        }
        if(strcmp(v2->t_slot,"char")==0)
        {
            aux.c_slot = (char)(v2->c_slot);
        }
        if(strcmp(v2->t_slot,"float")==0 || strcmp(v2->t_slot,"string")==0 || strcmp(v2->t_slot,"bool")==0)
        {
            aux.nume = strdup("eroare");
        }
    }
    if(strcmp(aux.t_slot,"bool")==0)
    {
        if(strcmp(v2->t_slot,"bool")==0)
        {
            aux.b_slot = strdup(v2->b_slot);
        }
        if(strcmp(v2->t_slot,"float")==0 || strcmp(v2->t_slot,"string")==0 || strcmp(v2->t_slot,"int")==0 || strcmp(v2->t_slot,"char")==0)
        {
            aux.nume = strdup("eroare");
        }
    }
    if(strcmp(aux.t_slot,"string")==0)
    {
        if(strcmp(v2->t_slot,"string")==0)
        {
            aux.s_slot = strdup(v2->s_slot);
        }
        if(strcmp(v2->t_slot,"float")==0 || strcmp(v2->t_slot,"bool")==0 || strcmp(v2->t_slot,"int")==0 || strcmp(v2->t_slot,"char")==0)
        {
            aux.nume = strdup("eroare");
        }
    }
    
    aux.id_variabila = lista_variabile.size();
    lista_variabile.push_back(aux);
}

void valoare_simbol( date_info* v)
{
    vector<date_info>::iterator it;
    for(it=lista_variabile.begin(); it!=lista_variabile.end(); ++it)
    {
        if(strcmp(v->nume,(it)->nume)==0)
            {
                if(strcmp((it)->t_slot,"int")==0)
                {
                    printf("\nValoarea variabilei \"%s\" este: %d\n",(it)->nume, (it)->i_slot);
                    break;
                }
                if(strcmp((it)->t_slot,"bool")==0)
                {
                    printf("\nValoarea variabilei \"%s\" este: %s\n",(it)->nume, (it)->b_slot);
                    break;
                }
                if(strcmp((it)->t_slot,"char")==0)
                {
                    printf("\nValoarea variabilei \"%s\" este: %c\n",(it)->nume, (it)->c_slot);
                    break;
                }
                if(strcmp((it)->t_slot,"float")==0)
                {
                    printf("\nValoarea variabilei \"%s\" este: %f\n",(it)->nume, (it)->f_slot);
                    break;
                }
                if(strcmp((it)->t_slot,"string")==0)
                {
                    printf("\nValoarea variabilei \"%s\" este: %s\n",(it)->nume, (it)->s_slot);
                    break;
                }
            }
    }
}

bool tip_date_permis(date_info* v1, date_info* v2)
{
    if(strcmp(v1->t_slot,"int")==0)
    {
        if(strcmp(v2->t_slot,"int")==0 || strcmp(v2->t_slot,"float")==0 || strcmp(v2->t_slot,"char")==0)
            return 1;
        return 0;
    }
    if(strcmp(v1->t_slot,"float")==0)
    {
        if(strcmp(v2->t_slot,"int")==0 || strcmp(v2->t_slot,"float")==0)
            return 1;
        return 0;
    }
    if(strcmp(v1->t_slot,"char")==0)
    {
        if(strcmp(v2->t_slot,"int")==0 || strcmp(v2->t_slot,"char")==0)
            return 1;
        return 0;
    }
    if(strcmp(v1->t_slot,"bool")==0)
    {
        if(strcmp(v2->t_slot,"bool")==0 )
            return 1;
        return 0;
    }
    if(strcmp(v1->t_slot,"string")==0)
    {
        if(strcmp(v2->t_slot,"string")==0)
            return 1;
        return 0;
    }
    return 0;
}

date_info assignment(date_info* v)
{
    date_info aux;

    vector<date_info>::iterator it;
    for(it=lista_variabile.begin(); it!=lista_variabile.end(); ++it)
    {
        if(strcmp(v->nume,(it)->nume)==0)
            {
                aux.t_slot = strdup((it)->t_slot);
                if(strcmp(aux.t_slot,"int")==0)
                {
                    aux.i_slot = (it)->i_slot;
                    return aux;
                }
                if(strcmp(aux.t_slot,"float")==0)
                {
                    aux.f_slot = (it)->f_slot;
                    return aux;
                }
                if(strcmp(aux.t_slot,"char")==0)
                {
                    aux.c_slot = (it)->c_slot;
                    return aux;
                }
                if(strcmp(aux.t_slot,"bool")==0)
                {
                    aux.b_slot = (it)->b_slot;
                    return aux;
                }
                if(strcmp(aux.t_slot,"string")==0)
                {
                    aux.s_slot = (it)->s_slot;
                    return aux;
                }
            }
    }
    printf("\n Variabila \"%s\" nu exista!\n",v->nume);
    aux.t_slot = strdup("eroare");
    return aux;
}

char* the_type(date_info* v)
{//pp ca exista variabila de fiecare data!
    vector<date_info>::iterator it;
    for(it=lista_variabile.begin(); it!=lista_variabile.end(); ++it)
    {
        if(strcmp(v->nume,(it)->nume)==0)
            {
                return strdup((it)->t_slot);
            }
    }
}

date_info exp_mul_id(date_info* v1, date_info* v2)
{
    date_info aux;
    v1->t_slot = strdup(the_type(v1));
    if(strcmp(v1->t_slot,"bool")==0 || strcmp(v2->t_slot,"bool")==0 || strcmp(v1->t_slot,"string")==0 || strcmp(v2->t_slot,"string")==0 )
    {
        aux.t_slot = strdup("eroare");
        return aux;
    }
    
    if(strcmp(v1->t_slot,"int")==0)
    {
        if(strcmp(v2->t_slot,"int")==0)
        {
            aux.t_slot = strdup("int");
            aux.i_slot = v1->i_slot * v2->i_slot;
            return aux;
        }
        if(strcmp(v2->t_slot,"float")==0)
        {
            aux.t_slot = strdup("float");
            aux.f_slot = v1->i_slot * v2->f_slot;
            return aux;
        }
        if(strcmp(v2->t_slot,"char")==0)
        {
            aux.t_slot = strdup("char");
            aux.c_slot = v1->i_slot * v2->c_slot;
            return aux;
        }
    }
    if(strcmp(v1->t_slot,"float")==0)
    {
        if(strcmp(v2->t_slot,"char") == 0)
        {
            aux.t_slot = strdup("eroare");
            return aux;
        }
        if(strcmp(v2->t_slot,"int")==0)
        {
            aux.t_slot = strdup("float");
            aux.f_slot = v1->f_slot * v2->i_slot;
            return aux;
        }
        if(strcmp(v2->t_slot,"float")==0)
        {
            aux.t_slot = strdup("float");
            aux.f_slot = v1->f_slot * v2->f_slot;
            return aux;
        }
    }
    if(strcmp(v1->t_slot,"char")==0)
    {
        if(strcmp(v2->t_slot,"float")==0)
        {
            aux.t_slot = strdup("eroare");
            return aux;
        }
        if(strcmp(v2->t_slot,"int")==0)
        {
            aux.t_slot = strdup("char");
            aux.c_slot = v1->c_slot * v2->i_slot;
            return aux;
        }
        if(strcmp(v2->t_slot,"char")==0)
        {
            aux.t_slot = strdup("char");
            aux.c_slot = v1->c_slot * v2->c_slot;
            return aux;
        }
    }
    }

date_info exp_add_id(date_info* v1, date_info* v2)
{
    date_info aux;
    v1->t_slot = strdup(the_type(v1));
    if(strcmp(v1->t_slot,"bool")==0 || strcmp(v2->t_slot,"bool")==0)
    {
        aux.t_slot = strdup("eroare");
        return aux;
    }

    if(strcmp(v1->t_slot,"int")==0)
    {
        if(strcmp(v2->t_slot,"string")==0 || strcmp(v2->t_slot,"bool")==0)
        {
            aux.t_slot = strdup("eroare");
            return aux;
        }
        if(strcmp(v2->t_slot,"int")==0)
        {
            aux.t_slot = strdup("int");
            aux.i_slot = v1->i_slot + v2->i_slot;
            return aux;
        }
        if(strcmp(v2->t_slot,"float")==0)
        {
            aux.t_slot = strdup("float");
            aux.f_slot = v1->i_slot + v2->f_slot;
            return aux;
        }
        if(strcmp(v2->t_slot,"char")==0)
        {
            aux.t_slot = strdup("char");
            aux.c_slot = v1->i_slot + v2->c_slot;
            return aux;
        }
    }
    if(strcmp(v1->t_slot,"float")==0)
    {
        if(strcmp(v2->t_slot,"string")==0 || strcmp(v2->t_slot,"bool")==0 || strcmp(v2->t_slot,"char")==0)
        {
            aux.t_slot = strdup("eroare");
            return aux;
        }
        if(strcmp(v2->t_slot,"int")==0)
        {
            aux.t_slot = strdup("float");
            aux.f_slot = v1->f_slot + v2->i_slot;
            return aux;
        }
        if(strcmp(v2->t_slot,"float")==0)
        {
            aux.t_slot = strdup("float");
            aux.f_slot = v1->f_slot + v2->f_slot;
            return aux;
        }
    }
    if(strcmp(v1->t_slot,"char")==0)
    {
        if(strcmp(v2->t_slot,"float")==0 || strcmp(v2->t_slot,"bool")==0)
        {
            aux.t_slot = strdup("eroare");
            return aux;
        }
        if(strcmp(v2->t_slot,"int")==0)
        {
            aux.t_slot = strdup("char");
            aux.c_slot = v1->c_slot + v2->i_slot;
            return aux;
        }
        if(strcmp(v2->t_slot,"string")==0)
        {
            aux.t_slot = strdup("string");
            char* temp = new char[100]; temp[0]=v1->c_slot; strcat(temp,v2->s_slot); 
            aux.s_slot=strdup(temp);
            return aux;                                     
        }
        if(strcmp(v2->t_slot,"char")==0)
        {
            aux.t_slot = strdup("char");
            aux.c_slot = v1->c_slot + v2->c_slot;
            return aux;
        }
    }
    if(strcmp(v1->t_slot,"string")==0)
    {
        if(strcmp(v2->t_slot,"float")==0 || strcmp(v2->t_slot,"bool")==0 || strcmp(v2->t_slot,"int")==0)
        {
            aux.t_slot = strdup("eroare");
            return aux;
        }
        if(strcmp(v2->t_slot,"string")==0)
        {
            aux.t_slot = strdup("string");
            char* temp = strdup(v1->s_slot); strcat(temp,v2->s_slot);
            aux.s_slot=strdup(temp);        
            return aux;                                     
        }
        if(strcmp(v2->t_slot,"char")==0)
        {
            aux.t_slot = strdup("string");
            char* temp = strdup(v1->s_slot); temp[strlen(temp)]=v2->c_slot;
            temp[strlen(temp)+1]=NULL; aux.s_slot=strdup(temp);
            return aux;
        }
    }
}


date_info exp_div_id(date_info* v1, date_info* v2)
{
    date_info aux;
    v1->t_slot = strdup(the_type(v1));
    if(strcmp(v1->t_slot,"bool")==0 || strcmp(v2->t_slot,"bool")==0 || strcmp(v1->t_slot,"string")==0 || strcmp(v2->t_slot,"string")==0 )
    {
        aux.t_slot = strdup("eroare");
        return aux;
    }

    if(strcmp(v1->t_slot,"int")==0)
    {
        if(strcmp(v2->t_slot,"int")==0)
        {
            if(v2->i_slot==0)
            {
                aux.t_slot = strdup("eroare");
                return aux;
            }
            aux.t_slot = strdup("int");
            aux.i_slot = v1->i_slot / v2->i_slot;
            return aux;
        }
        if(strcmp(v2->t_slot,"float")==0)
        {
            if(v2->f_slot==.0f)
            {
                aux.t_slot = strdup("eroare");
                return aux;
            }
            aux.t_slot = strdup("float");
            aux.f_slot = v1->i_slot / v2->f_slot;
            return aux;
        }
        if(strcmp(v2->t_slot,"char")==0)
        {
            if(v2->c_slot==0)
            {
                aux.t_slot = strdup("eroare");
                return aux;
            }
            aux.t_slot = strdup("char");
            aux.c_slot = v1->i_slot / v2->c_slot;
            return aux;
        }
    }
    if(strcmp(v1->t_slot,"float")==0)
    {
        if(strcmp(v2->t_slot,"char") == 0)
        {
            aux.t_slot = strdup("eroare");
            return aux;
        }
        if(strcmp(v2->t_slot,"int")==0)
        {
            if(v2->i_slot==0)
            {
                aux.t_slot = strdup("eroare");
                return aux;
            }
            aux.t_slot = strdup("float");
            aux.f_slot = v1->f_slot / v2->i_slot;
            return aux;
        }
        if(strcmp(v2->t_slot,"float")==0)
        {
            if(v2->f_slot==.0f)
            {
                aux.t_slot = strdup("eroare");
                return aux;
            }
            aux.t_slot = strdup("float");
            aux.f_slot = v1->f_slot / v2->f_slot;
            return aux;
        }
    }
    if(strcmp(v1->t_slot,"char")==0)
    {
        if(strcmp(v2->t_slot,"float")==0)
        {
            aux.t_slot = strdup("eroare");
            return aux;
        }
        if(strcmp(v2->t_slot,"int")==0)
        {
            if(v2->i_slot==0)
            {
                aux.t_slot = strdup("eroare");
                return aux;
            }
            aux.t_slot = strdup("char");
            aux.c_slot = v1->c_slot / v2->i_slot;
            return aux;
        }
        if(strcmp(v2->t_slot,"char")==0)
        {
            if(v2->c_slot==0)
            {
                aux.t_slot = strdup("eroare");
                return aux;
            }
            aux.t_slot = strdup("char");
            aux.c_slot = v1->c_slot / v2->c_slot;
            return aux;
        }
    }
}

date_info exp_mod_id(date_info* v1, date_info* v2)
{
    date_info aux;
    v1->t_slot = strdup(the_type(v1));
    if(strcmp(v1->t_slot,"int") !=0 || strcmp(v2->t_slot,"int") !=0 )
    {
        aux.t_slot = strdup("eroare");
        return aux;
    }
    aux.t_slot = strdup("int");
    aux.i_slot = v1->i_slot % v2->i_slot;
    return aux;
}

date_info exp_pow_id(date_info* v1, date_info* v2)
{
    date_info aux;
    v1->t_slot = strdup(the_type(v1));
    if(strcmp(v1->t_slot,"bool") == 0 || strcmp(v2->t_slot,"bool") ==0 || strcmp(v1->t_slot,"char") == 0 || strcmp(v2->t_slot,"char") ==0 || strcmp(v1->t_slot,"string") == 0 || strcmp(v2->t_slot,"string") ==0 )
    {
        aux.t_slot = strdup("eroare");
        return aux;
    }
    if(strcmp(v1->t_slot,"int") == 0 )
    {
        if(strcmp(v2->t_slot,"int") ==0 )
        {
            aux.t_slot = strdup("int");
            aux.i_slot = pow(v1->i_slot,v2->i_slot);
            return aux;
        }
        if(strcmp(v2->t_slot,"float") ==0 )
        {
            aux.t_slot = strdup("float");
            aux.f_slot = pow(v1->i_slot,v2->f_slot);
            return aux;
        }
        
    }
    if(strcmp(v1->t_slot,"float") == 0 )
    {
        if(strcmp(v2->t_slot,"int") ==0 )
        {
            aux.t_slot = strdup("float");
            aux.f_slot = pow(v1->f_slot,v2->i_slot);
            return aux;
        }
        if(strcmp(v2->t_slot,"float") ==0 )
        {
            aux.t_slot = strdup("float");
            aux.f_slot = pow(v1->f_slot,v2->f_slot);
            return aux;
        }
        
    }
    
}

date_info exp_sub_id(date_info* v1, date_info* v2)
{
    date_info aux;
    v1->t_slot = strdup(the_type(v1));
    if(strcmp(v1->t_slot,"bool")==0 || strcmp(v2->t_slot,"bool")==0)
    {
        aux.t_slot = strdup("eroare");
        return aux;
    }

    if(strcmp(v1->t_slot,"int")==0)
    {
        if(strcmp(v2->t_slot,"string")==0 || strcmp(v2->t_slot,"bool")==0)
        {
            aux.t_slot = strdup("eroare");
            return aux;
        }
        if(strcmp(v2->t_slot,"int")==0)
        {
            aux.t_slot = strdup("int");
            aux.i_slot = v1->i_slot - v2->i_slot;
            return aux;
        }
        if(strcmp(v2->t_slot,"float")==0)
        {
            aux.t_slot = strdup("float");
            aux.f_slot = v1->i_slot - v2->f_slot;
            return aux;
        }
        if(strcmp(v2->t_slot,"char")==0)
        {
            aux.t_slot = strdup("char");
            aux.c_slot = v1->i_slot - v2->c_slot;
            return aux;
        }
    }
    if(strcmp(v1->t_slot,"float")==0)
    {
        if(strcmp(v2->t_slot,"string")==0 || strcmp(v2->t_slot,"bool")==0 || strcmp(v2->t_slot,"char")==0)
        {
            aux.t_slot = strdup("eroare");
            return aux;
        }
        if(strcmp(v2->t_slot,"int")==0)
        {
            aux.t_slot = strdup("float");
            aux.f_slot = v1->f_slot - v2->i_slot;
            return aux;
        }
        if(strcmp(v2->t_slot,"float")==0)
        {
            aux.t_slot = strdup("float");
            aux.f_slot = v1->f_slot - v2->f_slot;
            return aux;
        }
    }
    if(strcmp(v1->t_slot,"char")==0)
    {
        if(strcmp(v2->t_slot,"float")==0 || strcmp(v2->t_slot,"bool")==0)
        {
            aux.t_slot = strdup("eroare");
            return aux;
        }
        if(strcmp(v2->t_slot,"int")==0)
        {
            aux.t_slot = strdup("char");
            aux.c_slot = v1->c_slot - v2->i_slot;
            return aux;
        }
        if(strcmp(v2->t_slot,"string")==0)
        {
            aux.t_slot = strdup("string");
            char* temp = new char[100]; temp[0]=v1->c_slot; strcat(temp,v2->s_slot); 
            aux.s_slot=strdup(temp);
            return aux;                                     
        }
        if(strcmp(v2->t_slot,"char")==0)
        {
            aux.t_slot = strdup("char");
            aux.c_slot = v1->c_slot - v2->c_slot;
            return aux;
        }
    }
    if(strcmp(v1->t_slot,"string")==0)
    {
        if(strcmp(v2->t_slot,"float")==0 || strcmp(v2->t_slot,"bool")==0 || strcmp(v2->t_slot,"int")==0)
        {
            aux.t_slot = strdup("eroare");
            return aux;
        }
        if(strcmp(v2->t_slot,"string")==0)
        {
            aux.t_slot = strdup("string");
            char* p; char* temp = strdup(v1->s_slot);
            p=strstr(temp,v2->s_slot);
            while(p !=NULL) {strcpy(p,p+strlen(v2->s_slot)); p=strstr(p,v2->s_slot);}
            aux.s_slot=strdup(temp);      
            return aux;                                     
        }
        if(strcmp(v2->t_slot,"char")==0)
        {
            aux.t_slot = strdup("string");
            char* p; char* temp = strdup(v1->s_slot);
            p=strchr(temp,v2->c_slot);
            while(p !=NULL) {strcpy(p,p+1); p=strchr(p,v2->c_slot);}
            aux.s_slot=strdup(temp);                                        
            return aux;
        }
    }
}

bool raspuns_comp(date_info* v1, date_info* v2, char* comp)
{
    if(strcmp(v1->t_slot,"int")==0)
    {
        if(strcmp(v2->t_slot,"bool")==0 || strcmp(v2->t_slot,"char")==0 || strcmp(v2->t_slot,"string")==0)
        {
            printf("\nOperatia logica cu \"%s\" nu se poate efectua\n",comp);
            return 0;
        }
        if(strcmp(v2->t_slot,"int")==0)
        {
            if(strcmp(comp,"<")==0)
            {
                return v1->i_slot < v2->i_slot;
            }
            if(strcmp(comp,"<=")==0)
            {
                return v1->i_slot <= v2->i_slot;
            }
            if(strcmp(comp,">")==0)
            {
                return v1->i_slot > v2->i_slot;
            }
            if(strcmp(comp,">=")==0)
            {
                return v1->i_slot >= v2->i_slot;
            }
            if(strcmp(comp,"==")==0)
            {
                return v1->i_slot == v2->i_slot;
            }
            if(strcmp(comp,"!=")==0)
            {
                return v1->i_slot != v2->i_slot;
            }
        }
        if(strcmp(v2->t_slot,"float")==0)
        {
            if(strcmp(comp,"<")==0)
            {
                return v1->i_slot < v2->f_slot;
            }
            if(strcmp(comp,"<=")==0)
            {
                return v1->i_slot <= v2->f_slot;
            }
            if(strcmp(comp,">")==0)
            {
                return v1->i_slot > v2->f_slot;
            }
            if(strcmp(comp,">=")==0)
            {
                return v1->i_slot >= v2->f_slot;
            }
            if(strcmp(comp,"==")==0)
            {
                return v1->i_slot == v2->f_slot;
            }
            if(strcmp(comp,"!=")==0)
            {
                return v1->i_slot != v2->f_slot;
            }
        }
    }
    if(strcmp(v1->t_slot,"float")==0)
    {
        if(strcmp(v2->t_slot,"bool")==0 || strcmp(v2->t_slot,"char")==0 || strcmp(v2->t_slot,"string")==0)
        {
            printf("\nOperatia logica cu \"%s\" nu se poate efectua\n",comp);
            return 0;
        }
        if(strcmp(v2->t_slot,"int")==0)
        {
            if(strcmp(comp,"<")==0)
            {
                return v1->f_slot < v2->i_slot;
            }
            if(strcmp(comp,"<=")==0)
            {
                return v1->f_slot <= v2->i_slot;
            }
            if(strcmp(comp,">")==0)
            {
                return v1->f_slot > v2->i_slot;
            }
            if(strcmp(comp,">=")==0)
            {
                return v1->f_slot >= v2->i_slot;
            }
            if(strcmp(comp,"==")==0)
            {
                return v1->f_slot == v2->i_slot;
            }
            if(strcmp(comp,"!=")==0)
            {
                return v1->f_slot != v2->i_slot;
            }
        }
        if(strcmp(v2->t_slot,"float")==0)
        {
            if(strcmp(comp,"<")==0)
            {
                return v1->f_slot < v2->f_slot;
            }
            if(strcmp(comp,"<=")==0)
            {
                return v1->f_slot <= v2->f_slot;
            }
            if(strcmp(comp,">")==0)
            {
                return v1->f_slot > v2->f_slot;
            }
            if(strcmp(comp,">=")==0)
            {
                return v1->f_slot >= v2->f_slot;
            }
            if(strcmp(comp,"==")==0)
            {
                return v1->f_slot == v2->f_slot;
            }
            if(strcmp(comp,"!=")==0)
            {
                return v1->f_slot != v2->f_slot;
            }
        }
    }
    if(strcmp(v1->t_slot,"char")==0)
    {
        if(strcmp(v2->t_slot,"char") != 0)
        {
            printf("\nOperatia logica cu \"%s\" nu se poate efectua\n",comp);
            return 0;
        }
        if(strcmp(v2->t_slot,"char")==0)
        {
            if(strcmp(comp,"<")==0)
            {
                return v1->c_slot < v2->c_slot;
            }
            if(strcmp(comp,"<=")==0)
            {
                return v1->c_slot <= v2->c_slot;
            }
            if(strcmp(comp,">")==0)
            {
                return v1->c_slot > v2->c_slot;
            }
            if(strcmp(comp,">=")==0)
            {
                return v1->c_slot >= v2->c_slot;
            }
            if(strcmp(comp,"==")==0)
            {
                return v1->c_slot == v2->c_slot;
            }
            if(strcmp(comp,"!=")==0)
            {
                return v1->c_slot != v2->c_slot;
            }
        }
    }
    if(strcmp(v1->t_slot,"bool")==0)
    {
        if(strcmp(v2->t_slot,"bool") != 0)
        {
            printf("\nOperatia logica cu \"%s\" nu se poate efectua\n",comp);
            return 0;
        }
        if(strcmp(v2->t_slot,"bool")==0)
        {
            bool vv1;
            bool vv2;
            if(strcmp(v1->b_slot,"true")==0)
                vv1 = 1;
            else
                vv1 = 0;
            if(strcmp(v2->b_slot,"true")==0)
                vv2 = 1;
            else
                vv2 = 0;
            
            if(strcmp(comp,"<")==0)
            {
                return vv1 < vv2;
            }
            if(strcmp(comp,"<=")==0)
            {
                return vv1 <= vv2;
            }
            if(strcmp(comp,">")==0)
            {
                return vv1 > vv2;
            }
            if(strcmp(comp,">=")==0)
            {
                return vv1 >= vv2;
            }
            if(strcmp(comp,"==")==0)
            {
                return vv1 == vv2;
            }
            if(strcmp(comp,"!=")==0)
            {
                return vv1 != vv2;
            }
        }
    }
    if(strcmp(v1->t_slot,"string")==0)
    {
        if(strcmp(v2->t_slot,"string") != 0)
        {
            printf("\nOperatia logica cu \"%s\" nu se poate efectua\n",comp);
            return 0;
        }
        if(strcmp(v2->t_slot,"string")==0)
        {
            if(strcmp(comp,"<")==0)
            {
                if(strcmp(v1->s_slot,v2->s_slot) <0)
                    return 1;
                else
                    return 0;
            }
            if(strcmp(comp,"<=")==0)
            {
                if(strcmp(v1->s_slot,v2->s_slot)<=0)
                    return 1;
                else
                    return 0;
            }
            if(strcmp(comp,">")==0)
            {
                if(strcmp(v1->s_slot,v2->s_slot)>0)
                    return 1;
                else
                    return 0;
            }
            if(strcmp(comp,">=")==0)
            {
                if(strcmp(v1->s_slot,v2->s_slot)>=0)
                    return 1;
                else
                    return 0;
            }
            if(strcmp(comp,"==")==0)
            {
                if(strcmp(v1->s_slot,v2->s_slot)==0)
                    return 1;
                else
                    return 0;
            }
            if(strcmp(comp,"!=")==0)
            {
                if(strcmp(v1->s_slot,v2->s_slot)!=0)
                    return 1;
                else
                    return 0;
            }
        }
    }
}

void update_valoare(date_info* v1, date_info* v2)
{
    if(lista_variabile[v1->id_variabila].constant==1)
    {
        printf("\neroare: Variabila este constanta!\n");
        return;
    }

    if(strcmp(lista_variabile[v1->id_variabila].t_slot,"int")==0)
    {
        if(strcmp(v2->t_slot,"int")==0)
        {
            lista_variabile[v1->id_variabila].i_slot = (int)(v2->i_slot);
        }
        if(strcmp(v2->t_slot,"float")==0)
        {
            lista_variabile[v1->id_variabila].i_slot = (int)(v2->f_slot);
        }
        if(strcmp(v2->t_slot,"char")==0)
        {
            int aux_i = v2->c_slot - '0';
            lista_variabile[v1->id_variabila].i_slot = aux_i;
        }
        if(strcmp(v2->t_slot,"string")==0 || strcmp(v2->t_slot,"bool")==0 )
        {
            printf("\nExpresia nu este de tipul corect!\n");
        }
    }
    if(strcmp(lista_variabile[v1->id_variabila].t_slot,"float")==0)
    {
        if(strcmp(v2->t_slot,"int")==0)
        {
            lista_variabile[v1->id_variabila].f_slot = (float)(v2->i_slot);
        }
        if(strcmp(v2->t_slot,"float")==0)
        {
            lista_variabile[v1->id_variabila].f_slot = (float)(v2->f_slot);
        }
        if(strcmp(v2->t_slot,"string")==0 || strcmp(v2->t_slot,"char")==0 || strcmp(v2->t_slot,"bool")==0)
        {
            printf("\nExpresia nu este de tipul corect!\n");
        }
    }
    if(strcmp(lista_variabile[v1->id_variabila].t_slot,"char")==0)
    {
        if(strcmp(v2->t_slot,"int")==0)
        {
            lista_variabile[v1->id_variabila].c_slot = (char)(v2->i_slot + '0');
        }
        if(strcmp(v2->t_slot,"char")==0)
        {
            lista_variabile[v1->id_variabila].c_slot = (char)(v2->c_slot);
        }
        if(strcmp(v2->t_slot,"float")==0 || strcmp(v2->t_slot,"string")==0 || strcmp(v2->t_slot,"bool")==0)
        {
            printf("\nExpresia nu este de tipul corect!\n");
        }
    }
    if(strcmp(lista_variabile[v1->id_variabila].t_slot,"bool")==0)
    {
        if(strcmp(v2->t_slot,"bool")==0)
        {
            lista_variabile[v1->id_variabila].b_slot = strdup(v2->b_slot);
        }
        if(strcmp(v2->t_slot,"float")==0 || strcmp(v2->t_slot,"string")==0 || strcmp(v2->t_slot,"int")==0 || strcmp(v2->t_slot,"char")==0)
        {
            printf("\nExpresia nu este de tipul corect!\n");
        }
    }
    if(strcmp(lista_variabile[v1->id_variabila].t_slot,"string")==0)
    {
        if(strcmp(v2->t_slot,"string")==0)
        {
            lista_variabile[v1->id_variabila].s_slot = strdup(v2->s_slot);
        }
        if(strcmp(v2->t_slot,"float")==0 || strcmp(v2->t_slot,"bool")==0 || strcmp(v2->t_slot,"int")==0 || strcmp(v2->t_slot,"char")==0)
        {
            printf("\nExpresia nu este de tipul corect!\n");
        }
    }
}

%}
%code requires {struct expr_ptr{
        int i_slot;
        float f_slot;
        char* b_slot;
        char  c_slot;
        char* s_slot;
        char* t_slot;
        char* nume;
        int scope;
        unsigned size;
        int id_variabila;
        bool constant;
    };}
%union {

    struct expr_ptr ex;
    
}

%token main_progr power modulo IF ELSE WHILE plus minus multiply divide end_progr print AND OR
%token mai_mic mai_mare mai_mic_egal mai_mare_egal egalitate diferit TV CONSTANTa FOR

%token <ex.i_slot> INT
%token <ex.f_slot> FLOAT
%token <ex.c_slot> CHAR
%token <ex.s_slot> STRING
%token <ex.b_slot> BOOL 
%token <ex> CLASS FUNCTION
%token <ex> ID 


%type <ex.i_slot> conditie comparatie
%type <ex.nume> comp 
%type <ex.id_slot>  print_exp  
%type <ex>   expresie expresie_principala global vvariabile
%type <ex> variabile_INT variabile_BOOL variabile_CHAR variabile_STRING variabile_FLOAT instructiuni declaratii_globale declaratie
%type <ex> variabile_INT_ARR variabile_BOOL_ARR variabile_CHAR_ARR variabile_STRING_ARR variabile_FLOAT_ARR parametrii clase functii
%type <ex> variabile_INT_CONST variabile_BOOL_CONST variabile_CHAR_CONST variabile_STRING_CONST variabile_FLOAT_CONST

%left plus minus
%left multiply divide
%left power modulo
%start start

%nonassoc IF
%nonassoc ELSE 
%%
start               : global main_progr main_body 
                    | main_progr main_body 
                    ;

global              : declaratii_globale {sscope=nr_functii;}
                    | functii            {sscope=0;}
                    | functii global     {sscope=0;}
                    | declaratii_globale global {sscope=nr_functii;}
                    ;

main_body           : instructiuni        {nr_functii++; sscope=nr_functii;}                   
                    ;

instructiuni        : declaratie ';' instructiuni           
                    | declaratie ';'
                    | declaratie_const ';' instructiuni           
                    | declaratie_const ';'
                    | atribuiri ';'
                    | print_exp ';'
                    | instructiune_if
                    | atribuiri instructiuni
                    | print_exp ';' instructiuni
                    | instructiune_if instructiuni
                    | instructiune_while
                    | instructiune_while instructiuni
                    | end_progr {return 1;}
                    | clase
                    | clase instructiuni
                    | TV                        {printeaza_tabel();}
                    | TV instructiuni           {printeaza_tabel();}
                    | instructiune_for
                    | instructiune_for instructiuni
                    ;

instructiune_for    : FOR '(' atribuiri ';' conditie ';' atribuiri ')' '{' instructiuni '}'

clase               : CLASS ID '{' instructiuni '}' ';' {;}
                    ;

apel_functii        : ID '(' variabile ')' ';'

functii             : FUNCTION INT ID '(' parametrii ')' '{' instructiuni '}'  {sscope=nr_functii; nr_functii++; sscope--;}
                    | FUNCTION FLOAT ID '(' parametrii ')' '{' instructiuni '}'  {;}
                    | FUNCTION CHAR ID '(' parametrii ')' '{' instructiuni '}'  {;}
                    | FUNCTION BOOL ID '(' parametrii ')' '{' instructiuni '}'  {;}
                    | FUNCTION STRING ID '(' parametrii ')' '{' instructiuni '}'  {;}
                    ;

parametrii          : parametrii ';' declaratie {;}
                    | declaratie {;}
                    ;

instructiune_if     : IF '(' conditie ')' '{' instructiuni '}' ELSE '{' instructiuni '}'    {if($3==1) printf("\nRamuara 1\n"); else printf("\nRamura 2\n");}
                    | IF '(' conditie ')' '{' instructiuni '}'                              {if($3==1) printf("\nDA\n"); else printf("\nNU\n");}
                    ;

instructiune_while  : WHILE '(' conditie ')' '{' instructiuni '}'   {;}                  

conditie            : comparatie                    {$$=$1;}
                    | comparatie AND conditie       {if($1==1 && $3==1) $$=1; else $$=0;}
                    | comparatie OR conditie        {if($1==0 && $3==0) $$=0; else $$=1;}
                    ;

comparatie          : expresie comp expresie        {$$ = raspuns_comp((date_info*)&$1,(date_info*)&$3, $2);}
                    ;

comp                : mai_mic                               {$$=strdup("<");}
                    | mai_mare                              {$$=strdup(">");}
                    | mai_mic_egal                          {$$=strdup("<=");}
                    | mai_mare_egal                         {$$=strdup(">=");}
                    | egalitate                             {$$=strdup("==");}
                    | diferit                               {$$=strdup("!=");}
                    ;


declaratii_globale  : declaratie ';'                        {sscope=nr_functii;}
                    | declaratie_const  ';'                 {sscope=nr_functii;}
                    ;

declaratie_const    : CONSTANTa INT variabile_INT_CONST                 {$3.t_slot=strdup("int"); $3.scope=1;}
                    | CONSTANTa BOOL variabile_BOOL_CONST               {$3.t_slot=strdup("bool"); $3.scope=1;}
                    | CONSTANTa FLOAT variabile_FLOAT_CONST             {$3.t_slot=strdup("float"); $3.scope=1;}
                    | CONSTANTa CHAR variabile_CHAR_CONST               {$3.t_slot=strdup("char"); $3.scope=1;}
                    | CONSTANTa STRING variabile_STRING_CONST           {$3.t_slot=strdup("string"); $3.scope=1;}
                    ;

vvariabile          : variabile_INT     {;}
                    | varibaile_FLOAT   {;}
                    | varibaile_BOOL   {;}
                    | varibaile_CHAR   {;}
                    | varibaile_STRING   {;}
                    | variabile_INT_CONST     {;}
                    | varibaile_FLOAT_CONST   {;}
                    | varibaile_BOOL_CONST   {;}
                    | varibaile_CHAR_CONST   {;}
                    | varibaile_STRING_CONST   {;}
                    ;

variabile_INT_CONST       : ID '=' expresie_principala                          {$1.constant=1; $1.t_slot=strdup("int"); if(exist_p((date_info*)&$1)) printf("\nVariabila \"%s\" exista deja!", $1.nume); else if(tip_date_permis((date_info*)&$1,(date_info*)&$3)==0) {printf("\nVariabila \"%s\" are tipul: \"%s\" si nu poate primi tipul \"%s\"!\n", $1.nume, $1.t_slot, $3.t_slot);} else { rezerva_nume_valoare((date_info*)&$1,(date_info*)&$3); valoare_simbol((date_info*)&$1);}}
                          | ID '=' expresie_principala ',' variabile_INT_CONST  {$1.constant=1; $1.t_slot=strdup("int"); if(exist_p((date_info*)&$1)) printf("\nVariabila \"%s\" exista deja!", $1.nume); else if(tip_date_permis((date_info*)&$1,(date_info*)&$3)==0) {printf("\nVariabila \"%s\" are tipul: \"%s\" si nu poate primi tipul \"%s\"!\n", $1.nume, $1.t_slot, $3.t_slot);} else { rezerva_nume_valoare((date_info*)&$1,(date_info*)&$3); valoare_simbol((date_info*)&$1);}}
                          ; 

variabile_FLOAT_CONST      : ID '=' expresie_principala                             {$1.constant=1; $1.t_slot=strdup("float"); if(exist_p((date_info*)&$1)) printf("\nVariabila \"%s\" exista deja!", $1.nume); else if(tip_date_permis((date_info*)&$1,(date_info*)&$3)==0) {printf("\nVariabila \"%s\" are tipul: \"%s\" si nu poate primi tipul \"%s\"!\n", $1.nume, $1.t_slot, $3.t_slot);} else { rezerva_nume_valoare((date_info*)&$1,(date_info*)&$3); valoare_simbol((date_info*)&$1);}}
                           | ID '=' expresie_principala ',' variabile_FLOAT_CONST   {$1.constant=1; $1.t_slot=strdup("float"); if(exist_p((date_info*)&$1)) printf("\nVariabila \"%s\" exista deja!", $1.nume); else if(tip_date_permis((date_info*)&$1,(date_info*)&$3)==0) {printf("\nVariabila \"%s\" are tipul: \"%s\" si nu poate primi tipul \"%s\"!\n", $1.nume, $1.t_slot, $3.t_slot);} else { rezerva_nume_valoare((date_info*)&$1,(date_info*)&$3); valoare_simbol((date_info*)&$1);}}
                           ; 

variabile_BOOL_CONST      : ID '=' expresie_principala                           {$1.constant=1; $1.t_slot=strdup("bool"); if(exist_p((date_info*)&$1)) printf("\nVariabila \"%s\" exista deja!", $1.nume); else if(tip_date_permis((date_info*)&$1,(date_info*)&$3)==0) {printf("\nVariabila \"%s\" are tipul: \"%s\" si nu poate primi tipul \"%s\"!\n", $1.nume, $1.t_slot, $3.t_slot);} else { rezerva_nume_valoare((date_info*)&$1,(date_info*)&$3); valoare_simbol((date_info*)&$1);}}
                          | ID '=' expresie_principala ',' variabile_BOOL_CONST  {$1.constant=1; $1.t_slot=strdup("bool"); if(exist_p((date_info*)&$1)) printf("\nVariabila \"%s\" exista deja!", $1.nume); else if(tip_date_permis((date_info*)&$1,(date_info*)&$3)==0) {printf("\nVariabila \"%s\" are tipul: \"%s\" si nu poate primi tipul \"%s\"!\n", $1.nume, $1.t_slot, $3.t_slot);} else { rezerva_nume_valoare((date_info*)&$1,(date_info*)&$3); valoare_simbol((date_info*)&$1);}}
                          ; 

variabile_CHAR_CONST      : ID '=' expresie_principala                           {$1.constant=1; $1.t_slot=strdup("char"); if(exist_p((date_info*)&$1)) printf("\nVariabila \"%s\" exista deja!", $1.nume); else if(tip_date_permis((date_info*)&$1,(date_info*)&$3)==0) {printf("\nVariabila \"%s\" are tipul: \"%s\" si nu poate primi tipul \"%s\"!\n", $1.nume, $1.t_slot, $3.t_slot);} else { rezerva_nume_valoare((date_info*)&$1,(date_info*)&$3); valoare_simbol((date_info*)&$1);}}
                          | ID '=' expresie_principala ',' variabile_CHAR_CONST  {$1.constant=1; $1.t_slot=strdup("char"); if(exist_p((date_info*)&$1)) printf("\nVariabila \"%s\" exista deja!", $1.nume); else if(tip_date_permis((date_info*)&$1,(date_info*)&$3)==0) {printf("\nVariabila \"%s\" are tipul: \"%s\" si nu poate primi tipul \"%s\"!\n", $1.nume, $1.t_slot, $3.t_slot);} else { rezerva_nume_valoare((date_info*)&$1,(date_info*)&$3); valoare_simbol((date_info*)&$1);}}
                          ; 

variabile_STRING_CONST    : ID '=' expresie_principala                              {$1.constant=1; $1.t_slot=strdup("string"); if(exist_p((date_info*)&$1)) printf("\nVariabila \"%s\" exista deja!", $1.nume); else if(tip_date_permis((date_info*)&$1,(date_info*)&$3)==0) {printf("\nVariabila \"%s\" are tipul: \"%s\" si nu poate primi tipul \"%s\"!\n", $1.nume, $1.t_slot, $3.t_slot);} else { rezerva_nume_valoare((date_info*)&$1,(date_info*)&$3); valoare_simbol((date_info*)&$1);}}
                          | ID '=' expresie_principala ',' variabile_STRING_CONST   {$1.constant=1; $1.t_slot=strdup("string"); if(exist_p((date_info*)&$1)) printf("\nVariabila \"%s\" exista deja!", $1.nume); else if(tip_date_permis((date_info*)&$1,(date_info*)&$3)==0) {printf("\nVariabila \"%s\" are tipul: \"%s\" si nu poate primi tipul \"%s\"!\n", $1.nume, $1.t_slot, $3.t_slot);} else { rezerva_nume_valoare((date_info*)&$1,(date_info*)&$3); valoare_simbol((date_info*)&$1);}}
                          ; 

  

declaratie          : INT variabile_INT                     {$2.t_slot=strdup("int"); }
                    | FLOAT variabile_FLOAT                 {$2.t_slot=strdup("float"); }
                    | CHAR variabile_CHAR                   {$2.t_slot=strdup("char"); }
                    | BOOL variabile_BOOL                   {$2.t_slot=strdup("bool"); }
                    | STRING variabile_STRING               {$2.t_slot=strdup("string"); }
                    | INT variabile_INT_ARR                 {$2.t_slot=strdup("int"); }
                    | BOOL variabile_BOOL_ARR               {$2.t_slot=strdup("bool"); }
                    | FLOAT variabile_FLOAT_ARR             {$2.t_slot=strdup("float"); }
                    | CHAR variabile_CHAR_ARR               {$2.t_slot=strdup("char"); }
                    | STRING variabile_STRING_ARR           {$2.t_slot=strdup("string"); }
                    ;


variabile_INT_ARR       : ID '[' INT ']'                            {$1.constant=0; $1.t_slot=strdup("int"); if(exist_p((date_info*)&$1)) printf("\nVariabila \"%s\" exista deja!", $1.nume); else {$1.scope= sscope; rezerva_nume((date_info*)&$1);}}
                        | ID '[' INT ']' ',' variabile_INT_ARR      {$1.constant=0; $1.t_slot=strdup("int"); if(exist_p((date_info*)&$1)) printf("\nVariabila \"%s\" exista deja!", $1.nume); else {$1.scope= sscope; rezerva_nume((date_info*)&$1);}}
                        | ID '[' INT ']' ',' variabile_INT          {$1.constant=0; $1.t_slot=strdup("int"); if(exist_p((date_info*)&$1)) printf("\nVariabila \"%s\" exista deja!", $1.nume); else {$1.scope= sscope; rezerva_nume((date_info*)&$1);}}
                        ;  

variabile_FLOAT_ARR     : ID '[' INT ']'                              {$1.constant=0; $1.t_slot=strdup("float"); if(exist_p((date_info*)&$1)) printf("\nVariabila \"%s\" exista deja!", $1.nume); else {$1.scope= sscope; rezerva_nume((date_info*)&$1);}}
                        | ID '[' INT ']' ',' variabile_FLOAT_ARR      {$1.constant=0; $1.t_slot=strdup("float"); if(exist_p((date_info*)&$1)) printf("\nVariabila \"%s\" exista deja!", $1.nume); else {$1.scope= sscope; rezerva_nume((date_info*)&$1);}}
                        | ID '[' INT ']' ',' variabile_FLOAT          {$1.constant=0; $1.t_slot=strdup("float"); if(exist_p((date_info*)&$1)) printf("\nVariabila \"%s\" exista deja!", $1.nume); else {$1.scope= sscope; rezerva_nume((date_info*)&$1);}}
                        ;  

variabile_BOOL_ARR      : ID '[' INT ']'                             {$1.constant=0; $1.t_slot=strdup("bool"); if(exist_p((date_info*)&$1)) printf("\nVariabila \"%s\" exista deja!", $1.nume); else {$1.scope= sscope; rezerva_nume((date_info*)&$1);}}
                        | ID '[' INT ']' ',' variabile_BOOL_ARR      {$1.constant=0; $1.t_slot=strdup("bool"); if(exist_p((date_info*)&$1)) printf("\nVariabila \"%s\" exista deja!", $1.nume); else {$1.scope= sscope; rezerva_nume((date_info*)&$1);}}
                        | ID '[' INT ']' ',' variabile_BOOL          {$1.constant=0; $1.t_slot=strdup("bool"); if(exist_p((date_info*)&$1)) printf("\nVariabila \"%s\" exista deja!", $1.nume); else {$1.scope= sscope; rezerva_nume((date_info*)&$1);}}
                        ;  

variabile_CHAR_ARR      : ID '[' INT ']'                             {$1.constant=0; $1.t_slot=strdup("char"); if(exist_p((date_info*)&$1)) printf("\nVariabila \"%s\" exista deja!", $1.nume); else {$1.scope= sscope; rezerva_nume((date_info*)&$1);}}
                        | ID '[' INT ']' ',' variabile_CHAR_ARR      {$1.constant=0; $1.t_slot=strdup("char"); if(exist_p((date_info*)&$1)) printf("\nVariabila \"%s\" exista deja!", $1.nume); else {$1.scope= sscope; rezerva_nume((date_info*)&$1);}}
                        | ID '[' INT ']' ',' variabile_CHAR          {$1.constant=0; $1.t_slot=strdup("char"); if(exist_p((date_info*)&$1)) printf("\nVariabila \"%s\" exista deja!", $1.nume); else {$1.scope= sscope; rezerva_nume((date_info*)&$1);}}
                        ;  

variabile_STRING_ARR    : ID '[' INT ']'                               {$1.constant=0; $1.t_slot=strdup("string"); if(exist_p((date_info*)&$1)) printf("\nVariabila \"%s\" exista deja!", $1.nume); else {$1.scope= sscope; rezerva_nume((date_info*)&$1);}}
                        | ID '[' INT ']' ',' variabile_STRING_ARR      {$1.constant=0; $1.t_slot=strdup("string"); if(exist_p((date_info*)&$1)) printf("\nVariabila \"%s\" exista deja!", $1.nume); else {$1.scope= sscope; rezerva_nume((date_info*)&$1);}}
                        | ID '[' INT ']' ',' variabile_STRING          {$1.constant=0; $1.t_slot=strdup("string"); if(exist_p((date_info*)&$1)) printf("\nVariabila \"%s\" exista deja!", $1.nume); else {$1.scope= sscope; rezerva_nume((date_info*)&$1);}}
                        ;  



variabile_INT       : ID                                            {$1.constant=0; $1.t_slot=strdup("int"); if(exist_p((date_info*)&$1)) printf("\nVariabila \"%s\" exista deja!", $1.nume); else {$1.scope= sscope; rezerva_nume((date_info*)&$1);}}
                    | ID ',' variabile_INT                          {$1.constant=0; $1.t_slot=strdup("int"); if(exist_p((date_info*)&$1)) printf("\nVariabila \"%s\" exista deja!", $1.nume); else {$1.scope= sscope; rezerva_nume((date_info*)&$1);}}
                    | ID '=' expresie_principala                    {$1.constant=0; $1.t_slot=strdup("int"); if(exist_p((date_info*)&$1)) printf("\nVariabila \"%s\" exista deja!", $1.nume); else if(tip_date_permis((date_info*)&$1,(date_info*)&$3)==0) {printf("\nVariabila \"%s\" are tipul: \"%s\" si nu poate primi tipul \"%s\"!\n", $1.nume, $1.t_slot, $3.t_slot);} else {$1.scope= sscope; rezerva_nume_valoare((date_info*)&$1,(date_info*)&$3); valoare_simbol((date_info*)&$1);}}
                    | ID '=' expresie_principala ',' variabile_INT  {$1.constant=0; $1.t_slot=strdup("int"); if(exist_p((date_info*)&$1)) printf("\nVariabila \"%s\" exista deja!", $1.nume); else if(tip_date_permis((date_info*)&$1,(date_info*)&$3)==0) {printf("\nVariabila \"%s\" are tipul: \"%s\" si nu poate primi tipul \"%s\"!\n", $1.nume, $1.t_slot, $3.t_slot);} else {$1.scope= sscope; rezerva_nume_valoare((date_info*)&$1,(date_info*)&$3); valoare_simbol((date_info*)&$1);}}
                    | ID ',' variabile_INT_ARR                      {$1.constant=0; $1.t_slot=strdup("int"); if(exist_p((date_info*)&$1)) printf("\nVariabila \"%s\" exista deja!", $1.nume); else {$1.scope= sscope; rezerva_nume((date_info*)&$1);}}
                    ; 

variabile_FLOAT     : ID                                             {$1.constant=0; $1.t_slot=strdup("float"); if(exist_p((date_info*)&$1)) printf("\nVariabila \"%s\" exista deja!", $1.nume); else {$1.scope= sscope; rezerva_nume((date_info*)&$1);}}
                    | ID ',' variabile_FLOAT                         {$1.constant=0; $1.t_slot=strdup("float"); if(exist_p((date_info*)&$1)) printf("\nVariabila \"%s\" exista deja!", $1.nume); else {$1.scope= sscope; rezerva_nume((date_info*)&$1);}}
                    | ID '=' expresie_principala                     {$1.constant=0; $1.t_slot=strdup("float"); if(exist_p((date_info*)&$1)) printf("\nVariabila \"%s\" exista deja!", $1.nume); else if(tip_date_permis((date_info*)&$1,(date_info*)&$3)==0) {printf("\nVariabila \"%s\" are tipul: \"%s\" si nu poate primi tipul \"%s\"!\n", $1.nume, $1.t_slot, $3.t_slot);} else {$1.scope= sscope; rezerva_nume_valoare((date_info*)&$1,(date_info*)&$3); valoare_simbol((date_info*)&$1);}}
                    | ID '=' expresie_principala ',' variabile_FLOAT {$1.constant=0; $1.t_slot=strdup("float"); if(exist_p((date_info*)&$1)) printf("\nVariabila \"%s\" exista deja!", $1.nume); else if(tip_date_permis((date_info*)&$1,(date_info*)&$3)==0) {printf("\nVariabila \"%s\" are tipul: \"%s\" si nu poate primi tipul \"%s\"!\n", $1.nume, $1.t_slot, $3.t_slot);} else {$1.scope= sscope; rezerva_nume_valoare((date_info*)&$1,(date_info*)&$3); valoare_simbol((date_info*)&$1);}}
                    | ID ',' variabile_FLOAT_ARR                     {$1.constant=0; $1.t_slot=strdup("float"); if(exist_p((date_info*)&$1)) printf("\nVariabila \"%s\" exista deja!", $1.nume); else {$1.scope= sscope; rezerva_nume((date_info*)&$1);}}                       
                    ; 

variabile_BOOL      : ID                                             {$1.constant=0; $1.t_slot=strdup("bool"); if(exist_p((date_info*)&$1)) printf("\nVariabila \"%s\" exista deja!", $1.nume); else {$1.scope= sscope; rezerva_nume((date_info*)&$1);}}
                    | ID ',' variabile_BOOL                          {$1.constant=0; $1.t_slot=strdup("bool"); if(exist_p((date_info*)&$1)) printf("\nVariabila \"%s\" exista deja!", $1.nume); else {$1.scope= sscope; rezerva_nume((date_info*)&$1);}}
                    | ID '=' expresie_principala                     {$1.constant=0; $1.t_slot=strdup("bool"); if(exist_p((date_info*)&$1)) printf("\nVariabila \"%s\" exista deja!", $1.nume); else if(tip_date_permis((date_info*)&$1,(date_info*)&$3)==0) {printf("\nVariabila \"%s\" are tipul: \"%s\" si nu poate primi tipul \"%s\"!\n", $1.nume, $1.t_slot, $3.t_slot);} else {$1.scope= sscope; rezerva_nume_valoare((date_info*)&$1,(date_info*)&$3); valoare_simbol((date_info*)&$1);}}
                    | ID '=' expresie_principala ',' variabile_BOOL  {$1.constant=0; $1.t_slot=strdup("bool"); if(exist_p((date_info*)&$1)) printf("\nVariabila \"%s\" exista deja!", $1.nume); else if(tip_date_permis((date_info*)&$1,(date_info*)&$3)==0) {printf("\nVariabila \"%s\" are tipul: \"%s\" si nu poate primi tipul \"%s\"!\n", $1.nume, $1.t_slot, $3.t_slot);} else {$1.scope= sscope; rezerva_nume_valoare((date_info*)&$1,(date_info*)&$3); valoare_simbol((date_info*)&$1);}}
                    | ID ',' variabile_BOOL_ARR                      {$1.constant=0; $1.t_slot=strdup("bool"); if(exist_p((date_info*)&$1)) printf("\nVariabila \"%s\" exista deja!", $1.nume); else {$1.scope= sscope; rezerva_nume((date_info*)&$1);}}   
                    ; 

variabile_CHAR      : ID                                             {$1.constant=0; $1.t_slot=strdup("char"); if(exist_p((date_info*)&$1)) printf("\nVariabila \"%s\" exista deja!", $1.nume); else {$1.scope= sscope; rezerva_nume((date_info*)&$1);}}
                    | ID ',' variabile_CHAR                          {$1.constant=0; $1.t_slot=strdup("char"); if(exist_p((date_info*)&$1)) printf("\nVariabila \"%s\" exista deja!", $1.nume); else {$1.scope= sscope; rezerva_nume((date_info*)&$1);}}
                    | ID '=' expresie_principala                     {$1.constant=0; $1.t_slot=strdup("char"); if(exist_p((date_info*)&$1)) printf("\nVariabila \"%s\" exista deja!", $1.nume); else if(tip_date_permis((date_info*)&$1,(date_info*)&$3)==0) {printf("\nVariabila \"%s\" are tipul: \"%s\" si nu poate primi tipul \"%s\"!\n", $1.nume, $1.t_slot, $3.t_slot);} else {$1.scope= sscope; rezerva_nume_valoare((date_info*)&$1,(date_info*)&$3); valoare_simbol((date_info*)&$1);}}
                    | ID '=' expresie_principala ',' variabile_CHAR  {$1.constant=0; $1.t_slot=strdup("char"); if(exist_p((date_info*)&$1)) printf("\nVariabila \"%s\" exista deja!", $1.nume); else if(tip_date_permis((date_info*)&$1,(date_info*)&$3)==0) {printf("\nVariabila \"%s\" are tipul: \"%s\" si nu poate primi tipul \"%s\"!\n", $1.nume, $1.t_slot, $3.t_slot);} else {$1.scope= sscope; rezerva_nume_valoare((date_info*)&$1,(date_info*)&$3); valoare_simbol((date_info*)&$1);}}
                    | ID ',' variabile_CHAR_ARR                      {$1.constant=0; $1.t_slot=strdup("char"); if(exist_p((date_info*)&$1)) printf("\nVariabila \"%s\" exista deja!", $1.nume); else {$1.scope= sscope; rezerva_nume((date_info*)&$1);}}    
                    ; 

variabile_STRING    : ID                                               {$1.constant=0; $1.t_slot=strdup("string"); if(exist_p((date_info*)&$1)) printf("\nVariabila \"%s\" exista deja!", $1.nume); else {$1.scope= sscope; rezerva_nume((date_info*)&$1);}}
                    | ID ',' variabile_STRING                          {$1.constant=0; $1.t_slot=strdup("string"); if(exist_p((date_info*)&$1)) printf("\nVariabila \"%s\" exista deja!", $1.nume); else {$1.scope= sscope; rezerva_nume((date_info*)&$1);}}
                    | ID '=' expresie_principala                       {$1.constant=0; $1.t_slot=strdup("string"); if(exist_p((date_info*)&$1)) printf("\nVariabila \"%s\" exista deja!", $1.nume); else if(tip_date_permis((date_info*)&$1,(date_info*)&$3)==0) {printf("\nVariabila \"%s\" are tipul: \"%s\" si nu poate primi tipul \"%s\"!\n", $1.nume, $1.t_slot, $3.t_slot);} else {$1.scope= sscope; rezerva_nume_valoare((date_info*)&$1,(date_info*)&$3); valoare_simbol((date_info*)&$1);}}
                    | ID '=' expresie_principala ',' variabile_STRING  {$1.constant=0; $1.t_slot=strdup("string"); if(exist_p((date_info*)&$1)) printf("\nVariabila \"%s\" exista deja!", $1.nume); else if(tip_date_permis((date_info*)&$1,(date_info*)&$3)==0) {printf("\nVariabila \"%s\" are tipul: \"%s\" si nu poate primi tipul \"%s\"!\n", $1.nume, $1.t_slot, $3.t_slot);} else {$1.scope= sscope; rezerva_nume_valoare((date_info*)&$1,(date_info*)&$3); valoare_simbol((date_info*)&$1);}}
                    | ID ',' variabile_STRING_ARR                      {$1.constant=0; $1.t_slot=strdup("string"); if(exist_p((date_info*)&$1)) printf("\nVariabila \"%s\" exista deja!", $1.nume); else {$1.scope= sscope; rezerva_nume((date_info*)&$1);}}   
                    ; 

            
atribuiri           : ID '=' expresie ';'       {if(exist_p((date_info*)&$1)) {update_valoare((date_info*)&$1,(date_info*)&$3);} else printf("\n Variabila \"%s\" nu exista!\n",$1.nume);}
                    ;

print_exp           : print expresie_principala              {printeaza((date_info*)&($2));}   
                    ;

expresie_principala : expresie_principala plus expresie         {date_info temp = exp_add((date_info*)&$1,(date_info*)&$3); $$=*(expr_ptr*)&temp;}
                    | expresie_principala minus expresie        {date_info temp = exp_sub((date_info*)&$1,(date_info*)&$3); $$=*(expr_ptr*)&temp;}
                    | expresie_principala multiply expresie     {date_info temp = exp_mul((date_info*)&$1,(date_info*)&$3); $$=*(expr_ptr*)&temp;}
                    | expresie_principala divide expresie       {date_info temp = exp_div((date_info*)&$1,(date_info*)&$3); $$=*(expr_ptr*)&temp;}
                    | expresie_principala modulo expresie       {date_info temp = exp_mod((date_info*)&$1,(date_info*)&$3); $$=*(expr_ptr*)&temp;}
                    | expresie_principala power expresie        {date_info temp = exp_pow((date_info*)&$1,(date_info*)&$3); $$=*(expr_ptr*)&temp;}
                    | INT                           {$$.i_slot = $1; $$.t_slot = strdup("int");}
                    | FLOAT                         {$$.f_slot = $1; strcpy($$.t_slot,"float");}
                    | CHAR                          {$$.c_slot = $1; strcpy($$.t_slot,"char");}
                    | BOOL                          {$$.b_slot = strdup($1); strcpy($$.t_slot,"bool");}
                    | STRING                        {$$.s_slot = strdup($1); strcpy($$.t_slot,"string");}
                    | ID                            {date_info temp = assignment((date_info*)&$1); $$=*(expr_ptr*)&temp;}
                    ;

expresie            : ID                            {date_info temp = assignment((date_info*)&$1); $$=*(expr_ptr*)&temp;}
                    | INT                           {$$.i_slot = $1; strcpy($$.t_slot,"int");}
                    | FLOAT                         {$$.f_slot = $1; strcpy($$.t_slot,"float");}
                    | CHAR                          {$$.c_slot = $1; strcpy($$.t_slot,"char");}
                    | BOOL                          {$$.b_slot = strdup($1); strcpy($$.t_slot,"bool");}
                    | STRING                        {$$.s_slot = strdup($1); strcpy($$.t_slot,"string");}


                    | expresie plus ID              {date_info temp = exp_add_id((date_info*)&$1,(date_info*)&$3); $$=*(expr_ptr*)&temp;}
                    | expresie plus INT             {if(strcmp($1.t_slot,"float")==0)
                                                     {$$.f_slot=$1.f_slot+$3; $$.t_slot=strdup("float");}
                                                    else if(strcmp($1.t_slot, "char")==0)
                                                      {$$.c_slot=$1.c_slot+$3; $$.t_slot=strdup("char");}
                                                    else if(strcmp($1.t_slot, "int")==0)
                                                        {$$.i_slot=$1.i_slot+$3; $$.t_slot=strdup("int");}
                                                    else $$.t_slot=strdup("error");}
                    | expresie plus FLOAT           {if(strcmp($1.t_slot,"float")==0)
                                                     {$$.f_slot=$1.f_slot+$3; $$.t_slot=strdup("float");}
                                                    else if(strcmp($1.t_slot, "int")==0)
                                                        {$$.f_slot=$1.i_slot+$3; $$.t_slot=strdup("float");}
                                                    else $$.t_slot=strdup("error");}
                    | expresie plus BOOL            {$$.t_slot=strdup("error");}
                    | expresie plus CHAR            {if(strcmp($1.t_slot, "char")==0)
                                                      {$$.c_slot=$1.c_slot+$3; $$.t_slot=strdup("char");}
                                                    else if(strcmp($1.t_slot, "int")==0)
                                                        {$$.i_slot=$1.i_slot+$3; $$.t_slot=strdup("int");}
                                                    else if(strcmp($1.t_slot, "string")==0)
                                                        {char* temp = strdup($1.s_slot); temp[strlen(temp)]=$3; temp[strlen(temp)+1]=NULL; $$.s_slot=strdup(temp); $$.t_slot=strdup("string");}
                                                    else $$.t_slot=strdup("error");}
                    | expresie plus STRING          {if(strcmp($1.t_slot, "char")==0)
                                                      {char* temp = new char[100]; temp[0]=$1.c_slot; strcat(temp,$3); $$.s_slot=strdup(temp); $$.t_slot=strdup("string");}
                                                    else if(strcmp($1.t_slot, "string")==0)
                                                        {char* temp = strdup($1.s_slot); strcat(temp,$3); $$.s_slot=strdup(temp); $$.t_slot=strdup("string");}
                                                    else $$.t_slot=strdup("error");}
                    
                    | expresie minus ID              {date_info temp = exp_sub_id((date_info*)&$1,(date_info*)&$3); $$=*(expr_ptr*)&temp;}
                    | expresie minus INT             {if(strcmp($1.t_slot,"float")==0)
                                                     {$$.f_slot=$1.f_slot-$3; $$.t_slot=strdup("float");}
                                                    else if(strcmp($1.t_slot, "char")==0)
                                                      {$$.c_slot=$1.c_slot-$3; $$.t_slot=strdup("char");}
                                                    else if(strcmp($1.t_slot, "int")==0)
                                                        {$$.i_slot=$1.i_slot-$3; $$.t_slot=strdup("int");}
                                                    else $$.t_slot=strdup("error");}
                    | expresie minus FLOAT           {if(strcmp($1.t_slot,"float")==0)
                                                     {$$.f_slot=$1.f_slot-$3; $$.t_slot=strdup("float");}
                                                    else if(strcmp($1.t_slot, "int")==0)
                                                        {$$.f_slot=$1.i_slot-$3; $$.t_slot=strdup("float");}
                                                    else $$.t_slot=strdup("error");}
                    | expresie minus BOOL            {$$.t_slot=strdup("error");}
                    | expresie minus CHAR            {if(strcmp($1.t_slot, "char")==0)
                                                      {$$.c_slot=$1.c_slot-$3; $$.t_slot=strdup("char");}
                                                    else if(strcmp($1.t_slot, "int")==0)
                                                        {$$.i_slot=$1.i_slot-$3; $$.t_slot=strdup("int");}
                                                    else if(strcmp($1.t_slot, "string")==0)
                                                        {char* p; char* temp = strdup($1.s_slot); p=strchr(temp,$3); while(p !=NULL) {strcpy(p,p+1); p=strchr(p,$3);} $$.s_slot=strdup(temp); $$.t_slot=strdup("string");}
                                                    else $$.t_slot=strdup("error");}
                    | expresie minus STRING          {if(strcmp($1.t_slot, "string")==0)
                                                        {char* p; char* temp = strdup($1.s_slot); p=strstr(temp,$3); while(p !=NULL) {strcpy(p,p+strlen($3)); p=strstr(p,$3);} $$.s_slot=strdup(temp); $$.t_slot=strdup("string");}
                                                    else $$.t_slot=strdup("error");}
                    
                    | expresie multiply ID          {date_info temp = exp_mul_id((date_info*)&$1,(date_info*)&$3); $$=*(expr_ptr*)&temp;}

                    | expresie multiply INT         {if(strcmp($1.t_slot,"float")==0)
                                                     {$$.f_slot=$1.f_slot*$3; $$.t_slot=strdup("float");}
                                                    else if(strcmp($1.t_slot, "char")==0)
                                                      {$$.c_slot=$1.c_slot*$3; $$.t_slot=strdup("char");}
                                                    else if(strcmp($1.t_slot, "int")==0)
                                                        {$$.i_slot=$1.i_slot*$3; $$.t_slot=strdup("int");}
                                                    else $$.t_slot=strdup("error");}
                    | expresie multiply FLOAT       {if(strcmp($1.t_slot,"float")==0)
                                                     {$$.f_slot=$1.f_slot*$3; $$.t_slot=strdup("float");}
                                                    else if(strcmp($1.t_slot, "int")==0)
                                                        {$$.f_slot=$1.i_slot*$3; $$.t_slot=strdup("float");}
                                                    else $$.t_slot=strdup("error");}

                    | expresie multiply CHAR        {$$.t_slot=strdup("error");}
                    | expresie multiply BOOL        {$$.t_slot=strdup("error");}
                    | expresie multiply STRING      {$$.t_slot=strdup("error");}

                    | expresie divide ID          {date_info temp = exp_div_id((date_info*)&$1,(date_info*)&$3); $$=*(expr_ptr*)&temp;}
                    | expresie divide INT         { if($3==0) {$$.t_slot=strdup("error");}
                                                    else {if(strcmp($1.t_slot,"float")==0) 
                                                     {$$.f_slot=$1.f_slot/$3; $$.t_slot=strdup("float");}
                                                    else if(strcmp($1.t_slot, "char")==0) 
                                                      {$$.c_slot=$1.c_slot/$3; $$.t_slot=strdup("char");}
                                                    else if(strcmp($1.t_slot, "int")==0)
                                                        {$$.i_slot=$1.i_slot/$3; $$.t_slot=strdup("int");}
                                                    else $$.t_slot=strdup("error");}}
                    | expresie divide FLOAT       { if($3==.0f) {$$.t_slot=strdup("error");}
                                                    else if(strcmp($1.t_slot,"float")==0)
                                                     {$$.f_slot=$1.f_slot*$3; $$.t_slot=strdup("float");}
                                                    else if(strcmp($1.t_slot, "int")==0)
                                                        {$$.f_slot=$1.i_slot*$3; $$.t_slot=strdup("float");}
                                                    else $$.t_slot=strdup("error");}

                    | expresie divide CHAR        {$$.t_slot=strdup("error");}
                    | expresie divide BOOL        {$$.t_slot=strdup("error");}
                    | expresie divide STRING      {$$.t_slot=strdup("error");}
                    
                    | expresie power ID          {date_info temp = exp_pow_id((date_info*)&$1,(date_info*)&$3); $$=*(expr_ptr*)&temp;}
                    | expresie power INT         { if(strcmp($1.t_slot,"float")==0) 
                                                     {$$.f_slot=pow($1.f_slot,$3); $$.t_slot=strdup("float");}
                                                    else if(strcmp($1.t_slot, "int")==0)
                                                        {$$.i_slot=pow($1.i_slot,$3); $$.t_slot=strdup("int");}
                                                    else $$.t_slot=strdup("error");}
                    | expresie power FLOAT       { if(strcmp($1.t_slot,"float")==0)
                                                     {$$.f_slot=pow($1.f_slot,$3); $$.t_slot=strdup("float");}
                                                    else if(strcmp($1.t_slot, "int")==0)
                                                        {$$.f_slot=pow($1.i_slot,$3); $$.t_slot=strdup("float");}
                                                    else $$.t_slot=strdup("error");}

                    | expresie power CHAR        {$$.t_slot=strdup("error");}
                    | expresie power BOOL        {$$.t_slot=strdup("error");}
                    | expresie power STRING      {$$.t_slot=strdup("error");}

                    | expresie modulo ID          {date_info temp = exp_mod_id((date_info*)&$1,(date_info*)&$3); $$=*(expr_ptr*)&temp;}
                    | expresie modulo INT         {if(strcmp($1.t_slot, "int")==0)
                                                        {$$.i_slot=pow($1.i_slot,$3); $$.t_slot=strdup("int");}
                                                    else $$.t_slot=strdup("error");}
                    | expresie modulo FLOAT       {$$.t_slot=strdup("error");}
                    | expresie modulo CHAR        {$$.t_slot=strdup("error");}
                    | expresie modulo BOOL        {$$.t_slot=strdup("error");}
                    | expresie modulo STRING      {$$.t_slot=strdup("error");} 
                    ;


%%

int main(int argc, char* *argv)
{
    yyin = fopen(argv[1],"r");
    return yyparse ( );
}


// int yywrap()
//     {
//         return 1;
 //    }
void yyerror (char *s) {fprintf (stderr, "%s\n", s);} 
