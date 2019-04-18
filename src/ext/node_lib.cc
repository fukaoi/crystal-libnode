#include "node_lib.h"

void init(){
  node::Initialize("crytal-nodejs");
}

const char* eval(const char* js_code) {
  Local<Value> result = node::Evaluate(js_code).ToLocalChecked();
  Local<String> str = result->ToString();
  cout << str->IsString() << endl;
  cout << str->IsInt32() << endl;
  String::Utf8Value strObj(str);
  return ToCrystalString(strObj);
}

void callback() {
  while (node::ProcessEvents()) { }
}

void deinit() {
  node::Deinitialize();
}

const char* ToCrystalString(const String::Utf8Value &value)
{
  const char *val = *value ? *value : "<Failed string convert>";
  char *setval = new char[strlen(val) + 1];
  strcpy(setval, val);
  return (const char *)setval;
}

