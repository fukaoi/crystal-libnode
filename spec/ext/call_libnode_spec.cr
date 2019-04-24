require "../spec_helper"
require "../../tasks/defined.cr"
require "../../src/node"

file_name = "libnode_main"
describe file_name do
  it "Execute #{file_name}" do
    cmd = <<-CMD
      g++ \
      -g \
      -I #{NODEJS_SOURCE_DIR}/src/  \
      -I #{NODEJS_SOURCE_DIR}/deps/v8/include/ \
      -I #{NODEJS_SOURCE_DIR}/deps/uv/include/ \
      -I src/ext/ \
      -std=gnu++11  \
      spec/ext/#{file_name}.cc  \
      -L#{LIBRARY_DIR} #{LIBRARY_DIR}/libnode.so.#{LIBNODE_VERSION}  \
      -o /tmp/#{file_name}
    CMD
    system(cmd).should be_true
    system("LD_LIBRARY_PATH=#{LIBRARY_DIR} /tmp/#{file_name}").should be_true
  end
end
