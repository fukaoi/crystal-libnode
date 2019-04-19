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

/////// header
extern "C" {
  void init();
  const char* eval(const char* js_code);
  void callback();
  void deinit();
}

const char* toCrystalString(const String::Utf8Value &value);
const char* toCString(const String::Utf8Value &value);

typedef struct {
  char *crystal_type;
  char *js_response;
} TupleCr;

TupleCr createReponseType();
/////// header



void init(){
  node::Initialize("crytal-nodejs");
}

const char* eval(const char* js_code) {
  Local<Value> result = node::Evaluate(js_code).ToLocalChecked();
  Local<String> str = result->ToString();
  TupleCr tuple = createReponseType();
  cout << tuple.crystal_type << endl;
  cout << tuple.js_response << endl;
  String::Utf8Value strObj(str);
  return toCrystalString(strObj);
}

void callback() {
  while (node::ProcessEvents()) { }
}

void deinit() {
  node::Deinitialize();
}

const char* toCrystalString(const String::Utf8Value &value)
{
  const char *val = *value ? *value : "<Failed string convert>";
  char *setval = new char[strlen(val) + 1];
  strcpy(setval, val);
  return (const char *)setval;
}

TupleCr createReponseType() {
  TupleCr tuple;
  tuple.crystal_type = "String";
  tuple.js_response = "lskdklkl30030200202kokdkdkdkdkdkdkkd";
  return tuple;
} 

#endif // BRIDGE_H

