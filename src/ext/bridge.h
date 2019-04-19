#ifndef BRIDGE_H
#define BRIDGE_H
#include <string.h>
#include <string>
#include <iostream>
#include "node_lib.h"
#include "node.h"
#include "v8.h"

using namespace std;
using namespace v8;

extern "C" {
  void init();
  const char* eval(const char* js_code);
  void callback();
  void deinit();
  const char* evalResponseType(const char* js_code);
}

const char* toCrystalString(const String::Utf8Value &value);

typedef struct {
  const char* crystal_type;
  const char* js_response;
} TupleCr;

const char *checkReponseType(Local<Value> result);

#endif // BRIDGE_H
