#include <stdio.h>
#include <assert.h>
#include "node.h"
#include "node_lib.h"
#include "bridge.h"

using namespace std;

int main(int argc, char const *argv[])
{
  init();
  eval("const a = 'c test program';console.log(a);");
  // typed check;
  eval("1;");
  eval("'one';");
  eval("['one'];");
  eval("[0.00000000000000001, 0.000000000000002];");
  eval("() => {};");
  eval("111111111111111111111111111111111");
  eval("new Object();");
  eval("Symbol()");
  eval("null");
  eval("{num: 10}");
  eval("{}");
  callback();
  deinit();
  return 0;
}
