#ifndef SRC_NODE_LIB_H_
#define SRC_NODE_LIB_H_

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
{ // internals, provided for experienced users

/**
 * @brief Returns the `v8::Isolate` for Node.js.
 *
 * Returns a pointer to the currently used `v8::Isolate`, if the Node.js engine
 * is initialized already.
 * *Important* Use with caution, changing this object might break Node.js.
 * @return Pointer to the `v8::Isolate`.
 */
v8::Isolate *isolate();

/**
 * @brief Returns the `node::Environment` for Node.js.
 *
 * Returns a pointer to the currently used `node::Environment`, if the Node.js
 * engine is initialized already.
 * *Important* Use with caution, changing this object might break Node.js.
 * @return Pointer to the `node::Environment`.
 */
Environment *environment();

} // namespace internal

/**
 * @brief Configures the uv loop behavior, which is used within the Node.js
 * event loop.
 *
 * Contains various behavior patterns for the uv loop, which is used within
 * the Node.js event loop.
 * *Important*: Contains the same values as `uv_run_mode`.
 */
enum class UvLoopBehavior : int
{
    RUN_DEFAULT = UV_RUN_DEFAULT,
    ///< Processes events as long as events are available.

    RUN_ONCE = UV_RUN_ONCE,
    ///< Processes events once from the uv loop.
    ///< If there are currently no events, the loop will wait until at least
    ///< one event appeared.

    RUN_NOWAIT = UV_RUN_NOWAIT,
    ///< Processes events once from the uv loop. If there are currently no events,
    ///< the loop will *not* wait und return immediately.
};

/**
 * @brief Indicates if the Node.js event loop is executed by `RunEventLoop`.
 * @return True, if the Node.js event loop is executed by `RunEventLoop`.
 * False otherwise.
 */
bool eventLoopIsRunning();

/*********************************************************
 * Start Node.js engine
 *********************************************************/

/**
 * @brief Starts the Node.js engine without executing a concrete script.
 *
 * Starts the Node.js engine by executing bootstrap code.
 * This is required in order to load scripts (e.g. `Run`) or evaluate
 * JavaScript code (e.g. `Evaluate`).
 * Additionally, Node.js will not process any pending events caused by the
 * JavaScript execution as long as `ProcessEvents` or `RunEventLoop` is
 * not called.
 * @param program_name The name for the Node.js application.
 * @param node_args List of arguments for the Node.js engine.
 * @param evaluate_stdin Controls whether stdin is evaluated.
 * @return Potential errors are indicated by a return value not equal to 0.
 */
NODE_EXTERN int Initialize(const std::string &program_name = "node_lib",
                           const std::vector<std::string> &node_args = {},
                           const bool evaluate_stdin = false);

/**
 * @brief Starts the Node.js engine.
 *
 * Starts the Node.js engine by executing bootstrap code.
 * This is required in order to load scripts (e.g. `Run`) or evaluate
 * JavaScript code (e.g. `Evaluate`).
 * Additionally, Node.js will not process any pending events caused by the
 * JavaScript execution as long as `ProcessEvents` or `RunEventLoop` is
 * not called.
 * @param argc The number of arguments.
 * @param argv List of arguments for the Node.js engine,
 * where the first argument needs to be the program name.
 * The number of arguments must correspond to argc.
 * @param evaluate_stdin Controls whether stdin is evaluated.
 * @return Potential errors are indicated by a return value not equal to 0.
 */
NODE_EXTERN int Initialize(int argc,
                           const char **argv,
                           const bool evaluate_stdin = false);

/**
 * @brief Stops the Node.js engine and destroys all current state.
 *
 * Stops the Node.js engine.
 * This is done in two steps:
 * 1. Issues the Node.js event loop to no longer accept any incoming events.
 * 2. Waits for the event loop to be empty and then executes clean up code.
 */
NODE_EXTERN int Deinitialize();

/*********************************************************
 * Handle JavaScript events
 *********************************************************/

/**
 * @brief Executes the Node.js event loop once.
 *
 * Processes all currently pending events in the Node.js event loop.
 * This method returns immediately if there are no pending events.
 * @param behavior The uv event loop behavior.
 * @return True, if more events need to be processed. False otherwise.
 */
NODE_EXTERN bool ProcessEvents(
    UvLoopBehavior behavior = UvLoopBehavior::RUN_NOWAIT);

/**
 * @brief Starts the execution of the Node.js event loop. Calling the given
 * callback once per loop tick.
 *
 * Executes the Node.js event loop as long as events keep coming.
 * Once per loop execution, after events were processed, the given callback
 * is executed. The event loop can be paused by calling `StopEventLoop`.
 * @param behavior The uv event loop behavior.
 * @param callback The callback, which should be executed periodically while
 * the calling thread is blocked.
 */
NODE_EXTERN void RunEventLoop(
    const std::function<void()> &callback,
    UvLoopBehavior behavior = UvLoopBehavior::RUN_NOWAIT);

/*********************************************************
 * Stop Node.js engine
 *********************************************************/

/**
 * @brief Issues the Node.js event loop to stop.
 *
 * Issues the Node.js event loop to stop.
 * The event loop will finish its current execution. This means, that the loop
 * is not guaranteed to have stopped when this method returns.
 * The execution can be resumed by using `RunEventLoop` again.
 */
NODE_EXTERN void StopEventLoop();

/**
 * @brief Evaluates the given JavaScript code.
 *
 * Parses and runs the given JavaScipt code.
 * Note: This method is executed in the environment created by the
 * Initialize() function.
 * @param java_script_code The code to evaluate.
 * @return The return value of the evaluated code.
 */
NODE_EXTERN v8::MaybeLocal<v8::Value> Evaluate(const std::string &js_code);

/**
 * @brief Evaluates the given JavaScript code.
 *
 * Parses and runs the given JavaScipt code.
 * @param env The environment where this call should be executed.
 * @param java_script_code The code to evaluate.
 * @return The return value of the evaluated code.
 */
NODE_EXTERN v8::MaybeLocal<v8::Value> Evaluate(Environment *env,
                                               const std::string &js_code);

} // namespace node

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

#endif // SRC_NODE_LIB_H_

