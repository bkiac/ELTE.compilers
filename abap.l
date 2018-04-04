%option noyywrap c++ yylineno

%{
#include "Parserbase.h"
%}

DIGIT [0-9]
WS    [ \t\n]

%%

PROGRAM      return Parser::PROGRAM;

DATA{WS}*":" return Parser::DATA;
TYPE         return Parser::TYPE;
I            return Parser::INT;
B            return Parser::BOOL;

TRUE         return Parser::TRUE;
FALSE        return Parser::FALSE;

AND          return Parser::AND;
OR           return Parser::OR;
NOT          return Parser::NOT;

IF           return Parser::IF;
ELSEIF       return Parser::ELSEIF;
ELSE         return Parser::ELSE;
ENDIF        return Parser::ENDIF;

WHILE        return Parser::WHILE;
ENDWHILE     return Parser::ENDWHILE;

MOVE         return Parser::MOVE;
READ         return Parser::READ;
WRITE        return Parser::WRITE;

BY           return Parser::BY;
FROM         return Parser::FROM;
TO           return Parser::TO;

ADD          return Parser::ADD;
SUBTRACT     return Parser::SUBTRACT;
MULTIPLY     return Parser::MULTIPLY;
DIVIDE       return Parser::DIVIDE;
">"          return Parser::GREATER_THAN;
"<"          return Parser::SMALLER_THAN;
"="          return Parser::EQUALS;

"("          return Parser::OP; // OPENING_PARENTHESIS
")"          return Parser::CP; // CLOSING_PARENTHESIS


^"*".*$      // do nothing

","          return Parser::COMMA; 
"."          return Parser::EOS; // END_OF_STATEMENT

{DIGIT}+     return Parser::CONSTANT;
{WS}+        // do nothing

[a-zA-Z][a-zA-Z0-9]*  return Parser::VARIABLE;

. { std::cerr << "Lexical error in line " << lineno() << "." << std::endl; exit(1); }

%%