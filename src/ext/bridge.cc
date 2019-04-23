#include "bridge.h"

void init(){
  node::Initialize("crytal-nodejs");
}

Tuple eval(const char* js_code) {
  Local<Value> result;
  if (node::Evaluate(js_code).ToLocal(&result)) {
    Local<String> str = result->ToString();
    String::Utf8Value strObj(str);
    crtuple.type = checkReponseType(result);
    crtuple.response = toCrystalString(strObj);
  } 
  return crtuple;
}

const char* evalResponseType(const char* str) {
  Local<Value> result;
  const char* type  = "Undefined";
  if (node::Evaluate(str).ToLocal(&result)) {
    type = checkReponseType(result);
  } 
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
  } else if (result->IsSymbol()) {
    type = "Symbol";
  } else if (result->IsNull()) {
    type = "Nil";
  } else if (result->IsDate()) {
    type = "Date";
  } else if (result->IsRegExp()) {
    type = "RegExp";
  } else if (result->IsObject()) {
    type = "Object";
  } else if (result->IsUndefined()) {
    type = "Undefined";
  } else if (result->IsNativeError()) {
    type = "Exception";
  } else {
    type = "Other";
  }
  return type;
} 


