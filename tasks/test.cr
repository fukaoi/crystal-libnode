require "./defined"
require "../src/nodejs"

class TestC < LuckyCli::Task
  FILE_NAME = "main"
  summary "run spec/ext/#{FILE_NAME}.cc"

  def call
    build
    cmd = "LD_LIBRARY_PATH=#{LIBRARY_DIR} ./bin/#{FILE_NAME}"
    unless system(cmd)
      failed("Failed running")
    else
      success("Done")
    end
  end

  def build
    cmd = <<-CMD
      g++ \
      -g \
      -I #{NODEJS_SOURCE_DIR}/src/  \
      -I #{NODEJS_SOURCE_DIR}/deps/v8/include/ \
      -I #{NODEJS_SOURCE_DIR}/deps/uv/include/ \
      -I src/ext/ \
      -std=gnu++11  \
      spec/ext/#{FILE_NAME}.cc  \
      -L#{LIBRARY_DIR} #{LIBRARY_DIR}/libnode.so.#{LIBNODE_VERSION}  \
      -o ./bin/#{FILE_NAME}
    CMD
    system(cmd)
  end
end
