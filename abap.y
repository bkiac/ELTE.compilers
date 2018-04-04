%baseclass-preinclude <iostream>
%lsp-needed

%token PROGRAM

%token DATA
%token TYPE
%token INT BOOL

%token TRUE FALSE

%token IF ELSEIF ELSE ENDIF

%token WHILE ENDWHILE

%token MOVE
%token READ
%token WRITE

%token BY TO FROM

%token COMMA
%token EOS

%token VARIABLE
%token CONSTANT

%token ADD SUBTRACT
%token MULTIPLY DIVIDE

%left AND OR NOT
%left GREATER_THAN SMALLER_THAN EQUALS

%%


// program structure
start:
  PROGRAM VARIABLE EOS data body
  {
    std::cout << "start -> PROGRAM VARIABLE EOS data body" << std::endl;
  }
;

data:
  // epsilon
  {
    std::cout << "data -> epsilon" << std::endl;
  }
|
  DATA declarations EOS
  {
    std::cout << "data -> declarations" << std::endl;
  }
;

body:
  // epsilon
  {
    std::cout << "body -> epsilon" << std::endl;
  }
|
  statement statements
  {
    std::cout << "body -> statement statements" << std::endl;
  }
;

// declaration structures
declarations:
  declaration
  {
    std::cout << "declarations -> declaration" << std::endl;
  }
|
  declaration COMMA declarations
  {
    std::cout << "declarations -> declaration COMMA declarations" << std::endl;
  }
;

declaration:
  VARIABLE TYPE INT
  {
    std::cout << "declaration -> VARIABLE TYPE INT" << std::endl;
  }
|
  VARIABLE TYPE BOOL
  {
    std::cout << "declaration -> VARIABLE TYPE BOOL" << std::endl;
  }
;

// statement structures
statements:
  statement
  {
    std::cout << "statements -> statement" << std::endl;
  }
|
  statement statements
  {
    std::cout << "statements -> statement statements" << std::endl;
  }
;

statement:
  move
    {
      std::cout << "statement -> move" << std::endl;
    }
|
  read
  {
    std::cout << "statement -> read" << std::endl;
  }
|
  write
  {
    std::cout << "statement -> write" << std::endl;
  }
|
  add
  {
    std::cout << "statement -> add" << std::endl;
  }
|
  subtract
  {
    std::cout << "statement -> subtract" << std::endl;
  }
|
  multiply
  {
    std::cout << "statement -> multiply" << std::endl;
  }
|
  divide
  {
    std::cout << "statement -> divide" << std::endl;
  }
|
  loop
  {
    std::cout << "statement -> loop" << std::endl;
  }
|
  condition
  {
    std::cout << "statement -> condition" << std::endl;
  }
;

// specific statements
move:
  MOVE expression TO VARIABLE EOS
  {
    std::cout << "move -> MOVE expression TO VARIABLE EOS" << std::endl;
  }
;

read:
  READ TO VARIABLE EOS
  {
    std::cout << "read -> READ TO VARIABLE EOS" << std::endl;
  }
;

write:
  WRITE expression EOS
  {
    std::cout << "write -> WRITE expression EOS" << std::endl;
  }
;

add:
  ADD expression TO VARIABLE EOS
  {
    std::cout << "add -> ADD expression TO VARIABLE EOS" << std::endl;
  }
;

subtract:
  SUBTRACT expression FROM VARIABLE EOS
  {
    std::cout << "subtract -> SUBTRACT expression FROM VARIABLE EOS" << std::endl;
  }
;

multiply:
  MULTIPLY VARIABLE BY expression EOS
  {
    std::cout << "multiply -> MULTIPLY expression BY expression EOS" << std::endl;
  }
;

divide:
  DIVIDE VARIABLE BY expression EOS
  {
    std::cout << "divide -> DIVIDE expression BY expression EOS" << std::endl;
  }
;

// loop
loop:
  WHILE expression EOS statements ENDWHILE EOS
  {
    std::cout << "loop -> WHILE expression EOS statements ENDWHILE EOS" << std::endl;
  }
;

// condition structures
condition:
  IF expression EOS statements condition_elseifs ENDIF EOS
  {
    std::cout << "condition -> IF expression EOS statements condition_elseifs ENDIF EOS" << std::endl;
  }
|
  IF expression EOS statements condition_elseifs ELSE EOS statements ENDIF EOS
  {
    std::cout << "condition -> IF expression EOS statements condition_elseifs ELSE statements ENDIF EOS" << std::endl;
  }
;

condition_elseifs:
  // epsilon
  {
    std::cout << "condition_elseifs -> epsilon" << std::endl;
  }
|
  condition_elseif condition_elseifs
  {
    std::cout << "condition_elseifs -> condition_elseif condition_elseifs" << std::endl;
  }
;

condition_elseif:
  ELSEIF expression EOS statements
  {
    std::cout << "condition_elseif -> ELSEIF expression EOS statements" << std::endl;
  }
;

// expression structures
expression:
  CONSTANT
  {
    std::cout << "expression -> CONSTANT" << std::endl;
  }
|
  TRUE
  {
    std::cout << "expression -> TRUE" << std::endl;
  }
|
  FALSE
  {
    std::cout << "expression -> FALSE" << std::endl;
  }
|
  VARIABLE
  {
    std::cout << "expression -> VARIABLE" << std::endl;
  }
|
  expression GREATER_THAN expression
  {
    std::cout << "expression -> expression GREATER_THAN expression" << std::endl;
  }
|
  expression SMALLER_THAN expression
  {
    std::cout << "expression -> expression SMALLER_THAN expression" << std::endl;
  }
|
  expression EQUALS expression
  {
    std::cout << "expression -> expression EQUALS expression" << std::endl;
  }
|
  expression AND expression
  {
    std::cout << "expression -> expression AND expression" << std::endl;
  }
|
  expression OR expression
  {
    std::cout << "expression -> expression OR expression" << std::endl;
  }
|
  NOT expression
  {
    std::cout << "expression -> NOT expression" << std::endl;
  }
;