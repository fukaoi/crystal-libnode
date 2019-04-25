require "./node/*"

module Node
  extend self

  @@v8_initialize = false
  @@v8_finalyze = false

  def v8_initialize=(status)
    @@v8_initialize = status
  end

  def v8_initialize?
    @@v8_initialize 
  end

  def v8_finalyze=(status)
    @@v8_finalyze = status
  end

  def v8_finalyze?
    @@v8_finalyze 
  end

  class Js
    def initialize
      unless Node.v8_initialize?
        LibNodeJs.init 
        Node.v8_initialize = true
      end
    end

    def eval(source_code : String)
      res = LibNodeJs.eval(source_code)
      LibNodeJs.callback
      String.new(res.response)
    end

    def evalSync(source_code : String) 
      res = LibNodeJs.eval(source_code)
      LibNodeJs.callback
    end

    def run(source_file_path : Stirng)

    end
    
    def runSync(source_file_path : Stirng)

    end

    def finalize
      unless Node.v8_finalyze?
        LibNodeJs.deinit
        Node.v8_finalyze = true
      end
    end
  end

  module Npm
    extend self
    CPULS_SOURCE_DIR = "src/ext"

    def init(dir : String = "/tmp") 
      raise "Failed npm init" unless system("cd #{dir};#{Node::Npm.path} init --yes > /dev/null")
    end

    def is_installed?(package_name : String) : Bool
      status = false
      status |= File.directory?("#{ENV["PWD"]}/node_modules/#{package_name}")
      if ENV.has_key?("NODE_PATH")
        status |= File.directory?("#{ENV["NODE_PATH"]}/node_modules/#{package_name}")
      end
      return status
    end

    def path(version = "") : String
      if version.blank?
        versions = parse_node_version
      else
        versions = parse_node_version(version)
      end
      "#{ENV["PWD"]}/bin/node-#{versions[0]}/bin/npm"
    end

    def parse_node_version(version = "") : Array(String)
      if version.blank?
        version = Dir.glob("#{CPULS_SOURCE_DIR}/v*").sort { |a, b| b <=> a }[0]
      end
      versions = File.basename(version).split("_")
    end

    def security_check
    end
  end
end
