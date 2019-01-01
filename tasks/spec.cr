require "lucky_cli"

class Spec < LuckyCli::Task
  banner "Spec all test and spec file select test"

  def call
    init_npm
    main_cmd = "NODE_PATH=#{NODE_MODULES_DIR} LD_LIBRARY_PATH=#{LIBRARY_DIR} crystal spec -d --error-trace -v"
    if ARGV.size > 0
      raise Exception.new("Failed a spec") unless system("#{main_cmd} #{ARGV[0]}")
    else
      raise Exception.new("Failed all spec") unless system("#{main_cmd} spec/")
    end
    success("Done spec")
  rescue e : Exception
    failed(e.to_s)
  end

  private def init_npm
    raise "Failed npm init" unless system("cd /tmp; npm init --yes")
  end
end
