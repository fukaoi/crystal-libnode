#include "bridge.h"

void init(){
  node::Initialize("crytal-nodejs");
}

const char* eval(const char* js_code) {
  Local<Value> result = node::Evaluate(js_code).ToLocalChecked();
  const char* type = checkReponseType(result);
  cout << type << endl;
  Local<String> str = result->ToString();
  // cout << tuple.crystal_type << endl;
  // cout << tuple.js_response << endl;
  String::Utf8Value strObj(str);
  return toCrystalString(strObj);
}

const char* evalResponseType(const char* str) {
  Local<Value> result = node::Evaluate(str).ToLocalChecked();
  const char* type = checkReponseType(result);
  return type;
}


void callback() {
  while (node::ProcessEvents()) { }
}

void deinit() {
  node::Deinitialize();
}

const char* toCrystalString(const String::Utf8Value &value) {
  const char *val = *value ? *value : "<Failed string convert>";
  char *setval = new char[strlen(val) + 1];
  strcpy(setval, val);
  return (const char *)setval;
}

const char* checkReponseType(Local<Value> result) {
  // TupleCr tuple;
  const char* type;
  if (result->IsBoolean()) {
    type = "Boolean";
  } else if (result->IsString()) {
    type = "String";
  } else if (result->IsInt32()) {
    type = "Int32";
  } else if (result->IsArray()) {
    type = "Array";
  } else if (result->IsFloat64Array()) {
    type = "Float64Array";
  } else if (result->IsFunction()) {
    type = "Function";
  } else if (result->IsNumber()) {
    type = "Number";
  } else if (result->IsObject()) {
    type = "Object";
  } else if (result->IsSymbol()) {
    type = "Symbol";
  } else if (result->IsNull()) {
    type = "Nil";
  } else {
    type = "Other";
  }

  // tuple.crystal_type = "String";
  // tuple.js_response = "lskdklkl30030200202kokdkdkdkdkdkdkkd";
  return type;
} 


