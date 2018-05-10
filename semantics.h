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
  std::string label;

  variable_data() {}
  variable_data(int d, type v, int counter) : decl_line(d), var_type(v) {
    std::stringstream lab;
    lab << "Label" << counter;
    label = lab.str();
  }
};

struct expression_data
{
  int line;
  type exp_type;
  std::string code;

  expression_data() {}
  expression_data(int l, type e, std::string c) : line(l), exp_type(e), code(c) {}
};

struct statement_data
{
  int line;
  std::string code;

  statement_data() {}
  statement_data(int l, std::string c) : line(l), code(c) {}
};

#endif