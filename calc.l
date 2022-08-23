%{
    #include <string.h>
    #include "calc.tab.h"

    int yylex();
    void yyerror(char* s);
%}

%%
"print"         {return print;}
"exit"          {return exit_cmd;}
[a-zA-Z]+       {strcpy(yylval.id, yytext); return identifier;}
[0-9]+          {yylval.num = atoi(yytext); return number;}
[ \t\n]         ;
[+-=*/;]        {return yytext[0];}
.               {ECHO; yyerror("Unexpected character");}

%%

int yywrap(void) {return 1;}