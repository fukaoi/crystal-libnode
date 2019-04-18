#ifndef NODE_LIB_H
#define NODE_LIB_H

#include <string>
#include <vector>
#include <map>
#include <functional>
#include <initializer_list>
#include "v8.h"
#include "uv.h"
#include "node.h"

namespace node
{

  namespace internal
  { 
    v8::Isolate *isolate();
    Environment *environment();
  }

  enum class UvLoopBehavior : int
  {
      RUN_DEFAULT = UV_RUN_DEFAULT,
      RUN_ONCE = UV_RUN_ONCE,
      RUN_NOWAIT = UV_RUN_NOWAIT,
  };

  bool eventLoopIsRunning();

  NODE_EXTERN int Initialize(const std::string &program_name = "node_lib",
                             const std::vector<std::string> &node_args = {},
                             const bool evaluate_stdin = false);

  NODE_EXTERN int Initialize(int argc,
                             const char **argv,
                             const bool evaluate_stdin = false);
  
  NODE_EXTERN int Deinitialize();

  NODE_EXTERN bool ProcessEvents(UvLoopBehavior behavior = UvLoopBehavior::RUN_NOWAIT);

  NODE_EXTERN void RunEventLoop(
    const std::function<void()> &callback,
    UvLoopBehavior behavior = UvLoopBehavior::RUN_NOWAIT);

  NODE_EXTERN void StopEventLoop();

  NODE_EXTERN v8::MaybeLocal<v8::Value> Evaluate(const std::string &js_code);

  NODE_EXTERN v8::MaybeLocal<v8::Value> Evaluate(Environment *env,
                                               const std::string &js_code);
}

using namespace std;
using namespace v8;

extern "C" {
  void init();
  const char* eval(const char* js_code);
  void callback();
  void deinit();
}

const char* ToCrystalString(const String::Utf8Value &value);
const char* ToCString(const String::Utf8Value &value);

#endif // NODE_LIB_H

