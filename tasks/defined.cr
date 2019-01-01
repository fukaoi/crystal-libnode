require "yaml"
require "colorize"

CPULS_SOURCE_DIR  = "src/ext"
EXTERNAL_DIR      = "externals"
NODEJS_SOURCE_DIR = "#{EXTERNAL_DIR}/node"
LIBRARY_DIR       = "libnode"
NODE_MODULES_DIR  = "/tmp/node_modules/"

###############################################

TOOLS_DIR = "tools"
DEPOT_DIR = "#{TOOLS_DIR}/depot_tools"
V8_DIR    = "#{TOOLS_DIR}/v8"

DEFAULT_ENV  = "test"
ENV_PATTERNS = {release: "release", development: "development", test: "test"}

NODE_VERSION    = parse_nodejs_version[0]
LIBNODE_VERSION = parse_nodejs_version[1]

begin
  ENV["LUCKY_ENV"]
rescue KeyError
  ENV["LUCKY_ENV"] = DEFAULT_ENV
end

unless ENV_PATTERNS.has_key?(ENV["LUCKY_ENV"])
  raise Exception.new("No match enviroment value: #{ENV["LUCKY_ENV"]}")
end

# def get_gn_dir
#   case ENV["LUCKY_ENV"]
#   when "release"
#     dir = GN_RELEASE_DIR
#   when "development"
#     dir = GN_DEVELOPMENT_DIR
#   when "test"
#     dir = GN_TEST_DIR
#   end
#   dir
# end

def parse_nodejs_version
  dir_names = Dir.glob("#{CPULS_SOURCE_DIR}/v*").sort { |a, b| b <=> a }[0]
  versions = File.basename(dir_names).split("_")
end

def build_nodejs
  system("cd ./#{NODEJS_SOURCE_DIR};./configure --debug --shared;make -j#{count_cpu}")
end

private def count_cpu
  System.cpu_count.to_i
end

def debug(message)
  puts "\n"
  puts "[DEBUG]:#{message.colorize(:blue)}"
  puts "\n"
end

def failed(message)
  puts message.colorize(:red)
end

def success(message)
  puts message.colorize(:green)
end
