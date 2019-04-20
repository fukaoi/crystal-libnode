#include <stdio.h>
#include <assert.h>
#include "node_lib.h"
#include "bridge.h"

using namespace std;

int main(int argc, char const *argv[]) {
  init();
  //// typed check ////
  printf("\n###### Type check #####\n");

  printf("true | ==> %s\n", evalResponseType("true"));
  printf("false | ==> %s\n", evalResponseType("true"));
  printf("undefined | ==> %s\n", evalResponseType("undefined"));
  printf("1 | ==> %s\n", evalResponseType("1"));
  printf("['one'] | ==> %s\n", evalResponseType("['one']"));
  printf("[0.00000000000000001, 0.000000000000002] | ==> %s\n", evalResponseType("[0.00000000000000001, 0.000000000000002]"));
  printf("() => {} | ==> %s\n", evalResponseType("() => {}"));
  printf("111111111111111111111111111111111 | ==> %s\n", evalResponseType("111111111111111111111111111111111"));
  printf("new Object() | ==> %s\n", evalResponseType("new Object()"));
  printf("Symbol() | ==> %s\n", evalResponseType("Symbol()"));
  printf("null | ==> %s\n", evalResponseType("null"));
  printf("{num: 10} | ==> %s\n", evalResponseType("{num: 10}"));
  printf("{} | ==> %s\n", evalResponseType("{}"));
  printf("new Date(1000) | ==> %s\n", evalResponseType("new Date(1000)"));
  printf("\"(empty)\" | ==> %s\n", evalResponseType(""));
  printf("{'val':'hogehoge'} | ==> %s\n", evalResponseType("{val: 'hogehoge'}"));
  printf("{10,20,30,40} | ==> %s\n", evalResponseType("{10,20,30,40}"));
  printf("{'a','b','c','d','e','f'} | ==> %s\n", evalResponseType("{'a','b','c','d','e','f'}"));
  printf("Throw exception | ==> %s\n", evalResponseType("try { \
          throw new Error('throwing test in libbridge_main.c'); \
        } catch(e) { \
          console.log('RAISE_EXCEPTION'); \
          console.log(e);}" \
        ));

  //// evaluate ////
  Tuple res;  
  res = eval("throw new Error('test');");
  res = eval("const a = 1;a * 9999;");
  printf("type:%s response:%s\n", res.type, res.response);
  res = eval("const calc = (n) => {return n / 10};calc(5);");
  printf("type:%s response:%s\n", res.type, res.response);
  callback();
  deinit();
  return 0;
}
