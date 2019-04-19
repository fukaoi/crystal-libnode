require "../spec_helper"
require "../../tasks/defined.cr"
require "../../src/node"

cc_file = "test_node_main"
describe cc_file do
  it "Execute #{cc_file}" do
    cmd = <<-CMD
      g++ \
      -g \
      -I #{NODEJS_SOURCE_DIR}/src/  \
      -I #{NODEJS_SOURCE_DIR}/deps/v8/include/ \
      -I #{NODEJS_SOURCE_DIR}/deps/uv/include/ \
      -I src/ext/ \
      -std=gnu++11  \
      spec/ext/#{cc_file}.cc  \
      -L#{LIBRARY_DIR} #{LIBRARY_DIR}/libnode.so.#{LIBNODE_VERSION}  \
      -o /tmp/#{cc_file}
    CMD
    system(cmd).should be_true
    system("LD_LIBRARY_PATH=#{LIBRARY_DIR} /tmp/#{cc_file}").should be_true
  end
end

c_file = "test_crystal_main"
describe c_file do
  it "Execute #{c_file}" do
    cmd = <<-CMD
      g++ \
      -g \
      -I #{NODEJS_SOURCE_DIR}/src/  \
      -I #{NODEJS_SOURCE_DIR}/deps/v8/include/ \
      -I #{NODEJS_SOURCE_DIR}/deps/uv/include/ \
      -I src/ext/ \
      -std=gnu++11  \
      spec/ext/#{c_file}.c \
      -o /tmp/#{c_file} \
      -L#{LIBRARY_DIR} \
      #{LIBRARY_DIR}/libbridge.so  \
      #{LIBRARY_DIR}/libnode.so.#{LIBNODE_VERSION} 
    CMD
    puts cmd
    system(cmd).should be_true
    system("LD_LIBRARY_PATH=#{LIBRARY_DIR} /tmp/#{c_file}").should be_true
  end
end
