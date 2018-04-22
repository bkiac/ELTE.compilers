%baseclass-preinclude "semantics.h"
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
%token EOS // END_OF_STATEMENT

%token <text> VARIABLE
%token <text> CONSTANT

%token ADD SUBTRACT
%token MULTIPLY DIVIDE

%token OP CP // OPENING_PARENTHESIS, CLOSING_PARENTHESIS

%left OR
%left AND
%left NOT
%left EQUALS
%left SMALLER_THAN GREATER_THAN

%type <exp> expression

%type <stm> declaration

%type <stm> loop

%type <stm> condition
%type <stm> condition_elseif

%type <stm> move
%type <stm> read
%type <stm> write

%type <stm> add
%type <stm> subtract
%type <stm> multiply
%type <stm> divide

%union
{
  std::string *text;
  expression_data *exp;
  statement_data *stm;
}

%%

// program structure
start:
  PROGRAM VARIABLE EOS data body
  {
  }
;

data:
  // epsilon
  {
  }
|
  DATA declarations EOS
  {
  }
;

body:
  // epsilon
  {
  }
|
  statements
  {
  }
;

// declaration structures
declarations:
  declaration
  {
  }
|
  declaration COMMA declarations
  {
  }
;

declaration:
  VARIABLE TYPE INT
  {
    if (symbol_table.count(*$1) > 0)
    {
      std::cerr << "Error in line: " << d_loc__.first_line << 
                   ". Variable '" << *$1 << "' has already been declared in line " << symbol_table[*$1].decl_line << "." << std::endl;
      exit(1);
    }
    else
    {
      symbol_table[*$1] = variable_data(d_loc__.first_line, integer);
    }

    delete $1;
  }
|
  VARIABLE TYPE BOOL
  {
    if (symbol_table.count(*$1) > 0)
    {
      std::cerr << "Error in line: " << d_loc__.first_line << 
                   ". Variable '" << *$1 << "' has already been declared in line " << symbol_table[*$1].decl_line << "." << std::endl;
      exit(1);                   
    }
    else
    {
      symbol_table[*$1] = variable_data(d_loc__.first_line, boolean);
    }

    delete $1;
  }
;

// statement structures
statements:
  statement
  {
  }
|
  statement statements
  {
  }
;

statement:
  move
  {
  }
|
  read
  {
  }
|
  write
  {
  }
|
  add
  {
  }
|
  subtract
  {
  }
|
  multiply
  {
  }
|
  divide
  {
  }
|
  loop
  {
  }
|
  condition
  {
  }
;

// specific statements
move:
  MOVE expression TO VARIABLE EOS
  {
    if (symbol_table.count(*$4) == 0)
    {
      std::cerr << "Error in line: " << d_loc__.first_line << 
                   ". Variable '" << *$4 << "' is undeclared." << std::endl;
      exit(1);
    } 
    else if (symbol_table[*$4].var_type != $2->exp_type)
    {
      std::cerr << "Error in line: " << d_loc__.first_line << 
                   ". Type mismatch." << std::endl;
      exit(1);
    }
    else
    {
      $$ = new statement_data(d_loc__.first_line);
    }

    delete $2;
    delete $4;
  }
;

read:
  READ TO VARIABLE EOS
  {
    if (symbol_table.count(*$3) == 0)
    {
      std::cerr << "Error in line: " << d_loc__.first_line << 
                   ". Variable '" << *$3 << "' is undeclared." << std::endl;
      exit(1);
    }
    else
    {
      $$ = new statement_data(d_loc__.first_line);
    }

    delete $3;
  }
;

write:
  WRITE expression EOS
  {
    $$ = new statement_data(d_loc__.first_line);

    delete $2;
  }
;

add:
  ADD expression TO VARIABLE EOS
  {
    if ($2->exp_type != integer)
    {
      std::cerr << "Error in line: " << $2->line << 
                   "Left operand is not an integer." << std::endl;
      exit(1);
    }

    if (symbol_table.count(*$4) == 0)
    {
      std::cerr << "Error in line: " << d_loc__.first_line << 
                   ". Variable '" << *$4 << "' is undeclared." << std::endl;
      exit(1);
    } 
    else if (symbol_table[*$4].var_type != integer)
    {
      std::cerr << "Error in line: " << d_loc__.first_line << 
                   ". Right operand is not an integer." << std::endl;
      exit(1);
    }

    $$ = new statement_data(d_loc__.first_line);
    
    delete $2;
    delete $4;
  }
;

subtract:
  SUBTRACT expression FROM VARIABLE EOS
  {
    if ($2->exp_type != integer)
    {
      std::cerr << "Error in line: " << $2->line << 
                   ". Left operand is not an integer." << std::endl;
      exit(1);
    }

    if (symbol_table.count(*$4) == 0)
    {
      std::cerr << "Error in line: " << d_loc__.first_line << 
                   ". Variable '" << *$4 << "' is undeclared." << std::endl;
      exit(1);
    } 
    else if (symbol_table[*$4].var_type != integer)
    {
      std::cerr << "Error in line: " << d_loc__.first_line << 
                   ". Right operand is not an integer." << std::endl;
      exit(1);
    }

    $$ = new statement_data(d_loc__.first_line);
    
    delete $2;
    delete $4;
  }
;

multiply:
  MULTIPLY VARIABLE BY expression EOS
  {
    if ($4->exp_type != integer)
    {
      std::cerr << "Error in line: " << $4->line << 
                   ". Right operand is not an integer." << std::endl;
      exit(1);
    }

    if (symbol_table.count(*$2) == 0)
    {
      std::cerr << "Error in line: " << d_loc__.first_line << 
                   ". Variable '" << *$2 << "' is undeclared." << std::endl;
      exit(1);
    } 
    else if (symbol_table[*$2].var_type != integer)
    {
      std::cerr << "Error in line: " << d_loc__.first_line << 
                   ". Left operand is not an integer." << std::endl;
      exit(1);
    }

    $$ = new statement_data(d_loc__.first_line);
    
    delete $2;
    delete $4;
  }
;

divide:
  DIVIDE VARIABLE BY expression EOS
  {
    if ($4->exp_type != integer)
    {
      std::cerr << "Error in line: " << $4->line << 
                   ". Right operand is not an integer." << std::endl;
      exit(1);
    }

    if (symbol_table.count(*$2) == 0)
    {
      std::cerr << "Error in line: " << d_loc__.first_line << 
                   ". Variable '" << *$2 << "' is undeclared." << std::endl;
      exit(1);
    } 
    else if (symbol_table[*$2].var_type != integer)
    {
      std::cerr << "Error in line: " << d_loc__.first_line << 
                   ". Left operand is not an integer." << std::endl;
      exit(1);
    }

    $$ = new statement_data(d_loc__.first_line);
    
    delete $2;
    delete $4;
  }
;

// loop
loop:
  WHILE expression EOS statements ENDWHILE EOS
  {
    if($2->exp_type != boolean)
    {
      std::cerr << "Error in line: " << d_loc__.first_line << 
                   ". Loop condition is not a boolean." << std::endl;
      exit(1);
    }
    else
    {
      $$ = new statement_data($2->line);
    }

    delete $2;
  }
;

// condition structures
condition:
  IF expression EOS statements condition_elseifs ENDIF EOS
  {
    if($2->exp_type != boolean)
    {
      std::cerr << "Error in line: " << d_loc__.first_line << 
                   ". Condition is not a boolean." << std::endl;
      exit(1);
    }
    else
    {
      $$ = new statement_data($2->line);
    }

    delete $2;
  }
|
  IF expression EOS statements condition_elseifs ELSE EOS statements ENDIF EOS
  {
    if($2->exp_type != boolean)
    {
      std::cerr << "Error in line: " << d_loc__.first_line << 
                   ". Condition is not a boolean." << std::endl;
      exit(1);
    }
    else
    {
      $$ = new statement_data($2->line);
    }
    
    delete $2;
  }
;

condition_elseifs:
  // epsilon
  {
  }
|
  condition_elseif condition_elseifs
  {
  }
;

condition_elseif:
  ELSEIF expression EOS statements
  {
    if($2->exp_type != boolean)
    {
      std::cerr << "Error in line: " << d_loc__.first_line << 
                   ". Condition is not a boolean." << std::endl;
      exit(1);
    }
    else
    {
      $$ = new statement_data($2->line);
    }
    
    delete $2;
  }
;

// expression structures
expression:
  CONSTANT
  {
    $$ = new expression_data(d_loc__.first_line, integer);
    
    delete $1;
  }
|
  TRUE
  {
    $$ = new expression_data(d_loc__.first_line, boolean);
  }
|
  FALSE
  {
    $$ = new expression_data(d_loc__.first_line, boolean);
  }
|
  VARIABLE
  {
    if(symbol_table.count(*$1) == 0)
    {
      std::cerr << "Error in line: " << d_loc__.first_line << 
                   ". Variable '" << *$1 << "' is undeclared." << std::endl;
      exit(1);
    }
    else
    {
      variable_data var = symbol_table[*$1];
      $$ = new expression_data(var.decl_line, var.var_type);

      delete $1;
    }
  }
|
  expression SMALLER_THAN expression
  {
    if ($1->exp_type != integer)
    {
      std::cerr << "Error in line: " << $1->line << 
                   ". Left operand is not an integer." << std::endl;
      exit(1);
    }

    if ($3->exp_type != integer)
    {
      std::cerr << "Error in line: " << $3->line << 
                   ". Right operand is not an integer." << std::endl;
      exit(1);
    }

    $$ = new expression_data(d_loc__.first_line, boolean);
    
    delete $1;
    delete $3;
  }
|
  expression GREATER_THAN expression
  {
    if ($1->exp_type != integer)
    {
      std::cerr << "Error in line: " << $1->line << 
                   ". Left operand is not an integer." << std::endl;
      exit(1);
    }

    if ($3->exp_type != integer)
    {
      std::cerr << "Error in line: " << $3->line << 
                   ". Right operand is not an integer." << std::endl;
      exit(1);
    }

    $$ = new expression_data(d_loc__.first_line, boolean);
    
    delete $1;
    delete $3;
  }
|
  expression EQUALS expression
  {
    if ($1->exp_type != $3->exp_type)
    {
      std::cerr << "Error in line: " << $1->line << 
                   ". Type mismatch." << std::endl;
      exit(1);
    }

    $$ = new expression_data(d_loc__.first_line, boolean);    

    delete $1;
    delete $3;
  }
|
  expression AND expression
  {
    if ($1->exp_type != boolean)
    {
      std::cerr << "Error in line: " << d_loc__.first_line << 
                   ". Left operand is not a boolean." << std::endl;
      exit(1);
    }

    if ($3->exp_type != boolean)
    {
      std::cerr << "Error in line: " << d_loc__.first_line << 
                   ". Right operand is not a boolean." << std::endl;
      exit(1);
    }

    $$ = new expression_data(d_loc__.first_line, boolean);
    
    delete $1;
    delete $3;
  }
|
  expression OR expression
  {
    if ($1->exp_type != boolean)
    {
      std::cerr << "Error in line: " << $1->line << 
                   ". Left operand is not a boolean." << std::endl;
      exit(1);
    }

    if ($3->exp_type != boolean)
    {
      std::cerr << "Error in line: " << $3->line << 
                   ". Right operand is not a boolean." << std::endl;
      exit(1);
    }

    $$ = new expression_data(d_loc__.first_line, boolean);
    
    delete $1;
    delete $3;
  }
|
  NOT expression
  {
    if ($2->exp_type != boolean)
    {
      std::cerr << "Error in line: " << $2->line << 
                   ". Operand is not a boolean." << std::endl;
      exit(1);
    }
    $$ = new expression_data(d_loc__.first_line, boolean);

    delete $2;
  }
|
  OP expression CP
  {
    $$ = $2;
  }
;
