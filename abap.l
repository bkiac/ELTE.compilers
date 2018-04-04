%option noyywrap c++ yylineno

%{

#include <iostream>
#include <cstdlib>

%}

DIGIT [0-9]
WS    [ \t\n]

%%

PROGRAM	 std::cout << "keyword: " << YYText() << std::endl;
DATA	 std::cout << "keyword: " << YYText() << std::endl;
TYPE     std::cout << "keyword: " << YYText() << std::endl;
I	 std::cout << "keyword: " << YYText() << std::endl;
B	 std::cout << "keyword: " << YYText() << std::endl;
TRUE	 std::cout << "keyword: " << YYText() << std::endl;
FALSE	 std::cout << "keyword: " << YYText() << std::endl;
AND	 std::cout << "keyword: " << YYText() << std::endl;
OR	 std::cout << "keyword: " << YYText() << std::endl;
NOT	 std::cout << "keyword: " << YYText() << std::endl;
IF	 std::cout << "keyword: " << YYText() << std::endl;
ELSEIF	 std::cout << "keyword: " << YYText() << std::endl;
ELSE	 std::cout << "keyword: " << YYText() << std::endl;
ENDIF	 std::cout << "keyword: " << YYText() << std::endl;
WHILE	 std::cout << "keyword: " << YYText() << std::endl;
ENDWHILE std::cout << "keyword: " << YYText() << std::endl;
MOVE	 std::cout << "keyword: " << YYText() << std::endl;
READ	 std::cout << "keyword: " << YYText() << std::endl;
TO	 std::cout << "keyword: " << YYText() << std::endl;

ADD       std::cout << "operator: " << YYText() << std::endl;
SUBSTRACT std::cout << "operator: " << YYText() << std::endl;
MULTIPLY  std::cout << "operator: " << YYText() << std::endl;
DIVIDE    std::cout << "operator: " << YYText() << std::endl;
">"       std::cout << "operator: " << YYText() << std::endl;
"<"       std::cout << "operator: " << YYText() << std::endl;
"="       std::cout << "operator: " << YYText() << std::endl;
":"       std::cout << "operator: " << YYText() << std::endl;

"("  std::cout << "opening_parenthesis" << std::endl;
")"  std::cout << "closing_parenthesis" << std::endl;

[a-zA-Z][a-zA-Z0-9]*  std::cout << "variable: " << YYText() << std::endl;

^"*".*$ std::cout << "comment: " << YYText()  << std::endl;

"," std::cout << "comma" << std::endl; 
"." std::cout << "end_of_statement" << std::endl;

{DIGIT}+  std::cout << "constant: " << YYText() << std::endl;
{WS}+

. { std::cerr << "Lexical error in line " << lineno() << "." << std::endl; exit(1); }

%%