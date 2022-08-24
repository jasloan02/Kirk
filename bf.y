// C definitions
%{
    #include <stdio.h>
    #include <stdlib.h>

    int yylex(void);
    void yyerror(char* s);

    const int ARR_SIZE = 30000;

    int ptr = 0;
    char array[ARR_SIZE];
%}

// Bison definitions
%union {char id;}
%start symbol
%token loop
%token line

// Grammar definitions
%%

symbol      :   '>'                 {ptr++;}
            |   '<'                 {ptr--;}
            |   '+'                 {array[ptr]++;}
            |   '-'                 {array[ptr]--;}
            |   ','                 {array[ptr] = getchar();} //figure out input (getchar(), I think)
            |   '.'                 {printf("%c", array[ptr]);}
            ;

%%

// C functions

int main(void) {
    return yyparse();
}

void yyerror(char* s) {
    fprintf(stderr, "%s\n", s);
}
