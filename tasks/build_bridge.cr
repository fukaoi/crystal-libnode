require "./defined"
require "file_utils"

class BuildBridge < LuckyCli::Task
  summary "Build a bridge program file"

  def call
    mkdir_need_dir
    copy_libnode
    build_bridge
    success("bridge program build done")
  rescue e : Exception
    failed(e.to_s)
  end

  private def build_bridge
    #todo: debug or release
    cmd = <<-CMD
      g++ \
      -g \
      -I#{NODEJS_SOURCE_DIR}/src/ \
      -I#{NODEJS_SOURCE_DIR}/deps/v8/include/ \
      -I#{NODEJS_SOURCE_DIR}/deps/uv/include/ \
      -I src/ext \
      -std=c++11 \
      -shared \
      -fPIC \
      src/ext/bridge.cc \
      -L#{LIBRARY_DIR}/libnode.so.#{LIBNODE_VERSION} \
      -o #{LIBRARY_DIR}/libbridge.so
    CMD
    puts cmd
    system(cmd)
  end

  private def mkdir_need_dir
    FileUtils.mkdir(LIBRARY_DIR) unless Dir.exists?(LIBRARY_DIR)
    FileUtils.mkdir("bin") unless Dir.exists?("bin")
  end

  private def copy_libnode
    FileUtils.cp(
      # "#{NODEJS_SOURCE_DIR}/out/Release/lib.target/libnode.so.#{LIBNODE_VERSION}",
      "#{NODEJS_SOURCE_DIR}/out/Debug/lib.target/libnode.so.#{LIBNODE_VERSION}",
      "#{LIBRARY_DIR}/libnode.so.#{LIBNODE_VERSION}"
    )
  end
end
