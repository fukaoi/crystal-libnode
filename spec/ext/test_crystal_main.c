#include <stdio.h>
#include "node_lib.h"

using namespace std;

int main(int argc, char const *argv[])
{
  init();
  eval("const a = 1; a *= 200;console.log(a)");
  callback();
  deinit();
  return 0;
}
