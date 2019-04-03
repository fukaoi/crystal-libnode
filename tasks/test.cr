require "./defined"
require "../src/nodejs"

class TestNpm < LuckyCli::Task
  FILE_NAME = "crystal_main"
  summary "For npm module test. run spec/ext/#{FILE_NAME}.cr"

  def call
    return failed("Not found npm name") unless ARGV.size == 1
    return failed("Please 'npm install #{ARGV[0]}'") unless Node::Npm.is_installed?(ARGV[0])
    build
    puts cmd = "NODE_PATH=#{NODE_MODULES_DIR} LD_LIBRARY_PATH=#{LIBRARY_DIR} ./bin/#{FILE_NAME} #{ARGV[0]}"
    unless system(cmd)
      failed("Failed running")
    else
      success("Done")
    end
  end

  def build
    unless system("crystal build --debug spec/ext/crystal_main.cr -o ./bin/crystal_main")
      failed("Crystal build failed")
    end
    success("Test Crystal main build done")
  end
end

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
