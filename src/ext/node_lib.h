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

using namespace std;
using namespace v8;

namespace node
{

  namespace internal
  { 
    Isolate *isolate();
    Environment *environment();
  }

  enum class UvLoopBehavior : int
  {
      RUN_DEFAULT = UV_RUN_DEFAULT,
      RUN_ONCE = UV_RUN_ONCE,
      RUN_NOWAIT = UV_RUN_NOWAIT,
  };

  bool eventLoopIsRunning();

  NODE_EXTERN int Initialize(const string &program_name = "node_lib",
                             const vector<string> &node_args = {},
                             const bool evaluate_stdin = false);

  NODE_EXTERN int Initialize(int argc,
                             const char **argv,
                             const bool evaluate_stdin = false);
  
  NODE_EXTERN int Deinitialize();

  NODE_EXTERN bool ProcessEvents(UvLoopBehavior behavior = UvLoopBehavior::RUN_NOWAIT);

  NODE_EXTERN void RunEventLoop(const function<void()> &callback, UvLoopBehavior behavior = UvLoopBehavior::RUN_NOWAIT);

  NODE_EXTERN MaybeLocal<Value> Evaluate(const string &js_code);

  NODE_EXTERN MaybeLocal<Value> Evaluate(Environment *env,
                                               const string &js_code);
}
#endif // NODE_LIB_H

