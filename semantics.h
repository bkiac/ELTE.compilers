#ifndef SEMANTICS_H
#define SEMANTICS_H

#include <string>
#include <iostream>
#include <sstream>

enum type { integer, boolean };

struct variable_data
{
  int decl_line;
  type var_type;

  variable_data() {}
  variable_data(int d, type v) : decl_line(d), var_type(v) {}
};

struct expression_data
{
  int line;
  type exp_type;

  expression_data() {}
  expression_data(int l, type e) : line(l), exp_type(e) {}
};

#endif