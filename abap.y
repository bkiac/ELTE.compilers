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

%type <stm> data
%type <stm> body

%type <stm> declaration
%type <stm> declarations

%type <stm> statement
%type <stm> statements

%type <stm> loop

%type <stm> condition
%type <stm> if
%type <stm> elseif
%type <stm> else

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
    std::cout 
      << "extern be_egesz" << std::endl
      << "extern ki_egesz" << std::endl
      << "extern be_logikai" << std::endl
      << "extern ki_logikai" << std::endl
      << "global main" << std::endl << std::endl
      << "section .bss" << std::endl
      << $4->code << std::endl
      << "section .text" << std::endl
      << "main:" << std::endl
      << $5->code << "ret" << std::endl;
    
    delete $4;
    delete $5;
  }
;

data:
  // epsilon
  {
    $$ = new statement_data(d_loc__.first_line, "");
  }
|
  DATA declarations EOS
  {
    $$ = new statement_data(d_loc__.first_line, $2->code);

    delete $2;
  }
;

body:
  // epsilon
  {
    $$ = new statement_data(d_loc__.first_line, "");
  }
|
  statements
  {
    $$ = new statement_data(d_loc__.first_line, $1->code);

    delete $1;
  }
;

// declaration structures
declarations:
  declaration
  {
    $$ = $1;
  }
|
  declaration COMMA declarations
  {
    $$ = new statement_data($1->line, 
      $1->code 
      + $3->code
    );

    delete $1;
    delete $3;
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
      symbol_table[*$1] = variable_data(d_loc__.first_line, integer, counter++);
      $$ = new statement_data(d_loc__.first_line, symbol_table[*$1].label + " resb 4\n");
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
      symbol_table[*$1] = variable_data(d_loc__.first_line, boolean, counter++);
      $$ = new statement_data(d_loc__.first_line, 
        symbol_table[*$1].label + " resb 1\n"
      );
    }

    delete $1;
  }
;

// statement structures
statements:
  statement
  {
    $$ = $1;
  }
|
  statement statements
  {
    $$ = new statement_data($1->line, 
      $1->code 
      + $2->code
    );
    
    delete $1;
    delete $2;
  }
;

statement:
  move
  {
    $$ = $1;
  }
|
  read
  {
    $$ = $1;
  }
|
  write
  {
    $$ = $1;
  }
|
  condition
  {
    $$ = $1;
  }
|
  loop
  {
    $$ = $1;
  }
|
  add
  {
    $$ = $1;
  }
|
  subtract
  {
    $$ = $1;
  }
|
  multiply
  {
    $$ = $1;
  }
|
  divide
  {
    $$ = $1;
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
      std::string reg;
      
      if ($2->exp_type == integer)
      {
        reg = "eax";
      }
      else
      {
        reg = "al";
      }

      $$ = new statement_data(d_loc__.first_line, 
        $2->code 
        + "mov " + "[" + symbol_table[*$4].label + "]," + reg + "\n" 
      );
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
      std::string op, reg;

      if (symbol_table[*$3].var_type == integer)
      {
        op = "be_egesz";
        reg = "eax";
      }
      else
      {
        op = "be_logikai";
        reg = "al";
      }

      $$ = new statement_data(d_loc__.first_line,
        "call " + op + "\n" 
        + "mov [" + symbol_table[*$3].label + "]," + reg + "\n"
      );
    }

    delete $3;
  }
;

write:
  WRITE expression EOS
  {
    std::string op;

    if ($2->exp_type == integer)
    {
      op = "ki_egesz";
    }
    else
    {
      op = "ki_logikai";
    }

    $$ = new statement_data(d_loc__.first_line,
      $2->code 
      + "push eax\n" 
      + "call " + op + "\n" 
      + "add esp,4\n"
    );

    delete $2;
  }
;

// condition structures
condition:
  if elseif else
  {
    $$ = new statement_data($1->line, 
      $1->code
      + $2->code
      + $3->code
    );
    
    delete $1;
    delete $2;
    delete $3;
  }
;

if:
  IF expression EOS statements
  {
    if($2->exp_type != boolean)
    {
      std::cerr << "Error in line: " << d_loc__.first_line << 
                   ". Condition is not a boolean." << std::endl;
      exit(1);
    }
    else
    {
      std::stringstream label1;
      label1 << "Label" << counter++;
      std::string elseif = label1.str();

      std::stringstream label2;
      counter_endif++;
      label2 << "Label_endif" << counter_endif;
      std::string endif = label2.str();

      $$ = new statement_data($2->line,
        $2->code
        + "cmp al,1\n"
        + "jne near " + elseif + "\n"
        + $4->code
        + "jmp " + endif + "\n"
        + elseif + ":\n"
      );
    }

    delete $2;
    delete $4;
  }
;

elseif:
  // epsilon
  {
    $$ = new statement_data(d_loc__.first_line, "");    
  }
|
  ELSEIF expression EOS statements elseif
  {
    if($2->exp_type != boolean)
    {
      std::cerr << "Error in line: " << d_loc__.first_line << 
                   ". Condition is not a boolean." << std::endl;
      exit(1);
    }
    else
    {
      std::stringstream label1;
      label1 << "Label" << counter++;
      std::string elseif = label1.str();

      std::stringstream label2;
      label2 << "Label_endif" << counter_endif;
      std::string endif = label2.str();

      $$ = new statement_data($2->line,
        $2->code
        + "cmp al,1\n"
        + "jne near " + elseif + "\n"
        + $4->code
        + "jmp " + endif + "\n"
        + elseif + ":\n"
        + $5->code
      );
    }

    delete $2;
    delete $4;
  }
;

else:
  ENDIF EOS
  {
    std::stringstream label;
    label << "Label_endif" << counter_endif;
    std::string endif = label.str();

    $$ = new statement_data(d_loc__.first_line, endif + ":\n");
  }
|
  ELSE EOS statements ENDIF EOS
  {
    std::stringstream label;
    label << "Label_endif" << counter_endif;
    std::string endif = label.str();

    $$ = new statement_data($3->line,
      $3->code
      + "jmp " + endif + "\n"
      + endif + ":\n"
    );

    delete $3;
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
      std::stringstream label1;
      label1 << "Label" << counter++;
      std::string start = label1.str();

      std::stringstream label2;
      label2 << "Label" << counter++;
      std::string block = label2.str();

      std::stringstream label3;
      label3 << "Label" << counter++;
      std::string end = label3.str();

      $$ = new statement_data($2->line,
        start + ":\n"
        + $2->code
        + "cmp al,1\n"
        + "je " + block + "\n"
        + "jmp " + end + "\n"
        + block + ":\n"
        + $4->code
        + "jmp " + start + "\n"
        + end + ":\n"
      );
    }

    delete $2;
    delete $4;
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
    
    $$ = new statement_data(d_loc__.first_line,
        $2->code
        + "push eax\n"
        + "mov eax,[" + symbol_table[*$4].label + "]\n"
        + "pop ebx\n"
        + "add eax,ebx\n"
        + "mov [" + symbol_table[*$4].label + "],eax\n"
    );    
    
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
    
    $$ = new statement_data(d_loc__.first_line,
      $2->code 
      + "push eax\n"
      + "mov eax,[" + symbol_table[*$4].label + "]\n"      
      + "pop ebx\n"
      + "sub eax,ebx\n"
      + "mov [" + symbol_table[*$4].label + "],eax\n"
    );

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

    $$ = new statement_data(d_loc__.first_line,
      $4->code
      + "push eax\n"
      + "mov eax,[" + symbol_table[*$2].label + "]\n"    
      + "pop ebx\n"
      + "mov edx,0\n"
      + "mul ebx\n"
      + "mov [" + symbol_table[*$2].label + "],eax\n"
    );
    
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
    
    $$ = new statement_data(d_loc__.first_line,
      $4->code
      + "push eax\n"
      + "mov eax,[" + symbol_table[*$2].label + "]\n"
      + "pop ebx\n"
      + "mov edx,0\n"
      + "div ebx\n"
      + "mov [" + symbol_table[*$2].label + "],eax\n"
    );

    delete $2;
    delete $4;
  }
;

// expression structures
expression:
  CONSTANT
  {
    $$ = new expression_data(d_loc__.first_line, integer, "mov eax," + *$1 + "\n");
    delete $1;
  }
|
  TRUE
  {
    $$ = new expression_data(d_loc__.first_line, boolean, "mov al,1\n");
  }
|
  FALSE
  {
    $$ = new expression_data(d_loc__.first_line, boolean, "mov al,0\n");
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
      std::string reg;
      
      if (var.var_type == integer)
      {
        reg = "eax";
      }
      else
      {
        reg = "al";
      }
      
      $$ = new expression_data(var.decl_line, var.var_type, "mov " + reg + ",[" + var.label + "]\n");

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

    std::stringstream label1;
    label1 << "Label" << counter++;
    std::string smaller = label1.str();

    std::stringstream label2;
    label2 << "Label" << counter++;
    std::string end = label2.str();

    $$ = new expression_data(d_loc__.first_line, boolean,
      $3->code
      + "push eax\n"
      + $1->code
      + "pop ebx\n"
      + "cmp eax,ebx\n"
      + "jb " + smaller + "\n"
      + "mov al,0\n"
      + "jmp " + end + "\n"
      + smaller + ":\n"
      + "mov al,1\n"
      + end + ":\n"
    );
    
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

    std::stringstream label1;
    label1 << "Label" << counter++;
    std::string greater = label1.str();

    std::stringstream label2;
    label2 << "Label" << counter++;
    std::string end = label2.str();

    $$ = new expression_data(d_loc__.first_line, boolean,
      $3->code
      + "push eax\n"
      + $1->code
      + "pop ebx\n"
      + "cmp eax,ebx\n"
      + "ja " + greater + "\n"
      + "mov al,0\n"
      + "jmp " + end + "\n"
      + greater + ":\n"
      + "mov al,1\n"
      + end + ":\n"
    );
    
    delete $1;
    delete $3;
  }
|
  expression EQUALS expression
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

    std::stringstream label1;
    label1 << "Label" << counter++;
    std::string equals = label1.str();

    std::stringstream label2;
    label2 << "Label" << counter++;
    std::string end = label2.str();

    $$ = new expression_data(d_loc__.first_line, boolean,
      $3->code
      + "push eax\n"
      + $1->code
      + "pop ebx\n"
      + "cmp eax,ebx\n"
      + "je " + equals + "\n"
      + "mov al,0\n"
      + "jmp " + end + "\n"
      + equals + ":\n"
      + "mov al,1\n"
      + end + ":\n"
    );   

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

    $$ = new expression_data(d_loc__.first_line, boolean,
      $3->code
      + "push ax\n"
      + $1->code
      + "pop bx\n"
      + "and al,bl\n"
    );
    
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

    $$ = new expression_data(d_loc__.first_line, boolean,
      $3->code
      + "push ax\n"
      + $1->code
      + "pop bx\n"
      + "or al,bl\n"
    );
    
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
    $$ = new expression_data(d_loc__.first_line, boolean, $2->code + "xor al,1\n");

    delete $2;
  }
|
  OP expression CP
  {
    $$ = $2;
  }
;
