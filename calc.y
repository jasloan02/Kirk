// C definitions
%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <ctype.h>

    int yylex(void);
    void yyerror(char* s);

    struct Variable {
        char name[20];
        int value;
    };
    struct Variable vars[10];
    int getVarVal(char varName[20]);
    void updateVarVal(char varName[20], int newVal);
%}

// Bison Definitions
%union {int num; char id[20];}
%start line
%token print
%token exit
%token <num> number
%token <id> identifier
%type <num> line exp term
%type <id> assignment

%%

line        : assignment ';'        {;}
            | exit ';'          {exit(EXIT_SUCCESS);}
            | print exp ';'         {printf("Output: %d\n", $2);}
            | line assignment ';'   {;}
            | line print exp ';'    {printf("Output: %d\n", $3);}
            | line exit ';'     {exit(EXIT_SUCCESS);}
            ;

assignment  : identifier '=' exp    {updateVarVal($1, $3);};

exp         : term                  {$$ = $1;}
            | exp '+' term          {$$ = $1 + $3;}
            | exp '-' term          {$$ = $1 - $3;}
            | exp '*' term          {$$ = $1 * $3;}
            | exp '/' term          {$$ = $1 / $3;}
            ;

term        : number                {$$ = $1;}
            | identifier            {$$ = getVarVal($1);}
            ;

%%

// C functions

int getVarVal(char varName[20]) {
    for (int i = 0; i < 10; i++) {
        if (!strcmp(vars[i].name, varName)) {
            return vars[i].value;
            break;
        }
    }
    return 0;
}

void updateVarVal(char varName[20], int newVal) {
    for (int i = 0; i < 10; i++) {
        if (!strcmp("\0", vars[i].name)) {
            printf("DEBUG: Set %s to %d\n", varName, newVal);
            strcpy(vars[i].name, varName);
            vars[i].value = newVal;
            return;
        }
        if (!strcmp(vars[i].name, varName)) {
            vars[i].value = newVal;
            return;
        }
    }
}

int main(void) {
    return yyparse();
}

void yyerror(char* s) {
    fprintf(stderr, "%s\n", s);
}