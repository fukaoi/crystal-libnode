#include "bridge.h"

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


