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
  typedef struct {
    const char* type;
    const char* response;
  } Tuple;

  void init();
  Tuple eval(const char* js_code);
  void callback();
  void deinit();
  const char* evalResponseType(const char* js_code);
  Tuple crtuple;
}

const char* toCrystalString(const String::Utf8Value &value);

const char *checkReponseType(Local<Value> result);

#endif // BRIDGE_H

