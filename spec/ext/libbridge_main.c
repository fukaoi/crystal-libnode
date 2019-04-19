#include <stdio.h>
#include "node.h"
#include "node_lib.h"
#include "bridge.h"

using namespace std;

int main(int argc, char const *argv[])
{
  init();
  eval("const a = 'c test program';console.log(a);");
  callback();
  deinit();
  return 0;
}
