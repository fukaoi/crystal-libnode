#include <stdio.h>
#include <string.h>
#include <iostream>
#include <string.h>
#include "v8.h"
#include "node.h"
#include "node_lib.h"

using namespace std;
using namespace v8;



int main(int argc, char const *argv[])
{
  node::Initialize("main");
  node::Evaluate("1 + 1");
  node::Evaluate("'Hello' + 'World'");
  node::Evaluate("const fn = (n) => { return (n * 10);}");
  node::Evaluate("fn(10)");
  node::Evaluate("const anony = () => {return fn(100)};anony()");
  node::Evaluate("new Date()");
  node::Evaluate("[1, 2, 3, 4]");
  node::Evaluate("new Float64Array(2);");
  node::Evaluate("null");
  node::Evaluate("true == true");
  node::Evaluate("false === false");
  node::Evaluate("Number('7')");
  node::Evaluate("Symbol('foo');");
  node::Evaluate("0.00000001");
  node::Evaluate("undefined");
  node::Evaluate("");
  node::Evaluate("throw new Error('throwing test in libnode_main.cc');");
  while (node::ProcessEvents()) { }
  node::Deinitialize();

  return 0;
}
