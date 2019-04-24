require "./node/*"

module Node
  extend self
  @@v8_initialize = false

  def set_v8_status(status : Bool) : Void
    @@v8_initialize = status
  end

  def get_v8_status? : Bool
    @@v8_initialize
  end

  class Js
    def initialize
      LibNodeJs.init unless Node.get_v8_status?
      Node.set_v8_status(true)
    end

    def eval(source_code : String)
      res = LibNodeJs.eval(source_code)
      LibNodeJs.callback
      String.new(res.response)
    end

    def finalize
      LibNodeJs.deinit
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
