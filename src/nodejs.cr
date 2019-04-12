require "./nodejs/*"

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
      String.new(res)
    end

    def finalize
      LibNodeJs.deinit
    end
  end

  module Npm
    extend self

    def is_installed?(package_name : String) : Bool
      status = false
      status |= File.directory?("#{ENV["PWD"]}/node_modules/#{package_name}")
      if ENV.has_key?("NODE_PATH")
        status |= File.directory?("#{ENV["NODE_PATH"]}/node_modules/#{package_name}")
      end
      return status
    end

    def security_check
    end
  end
end
