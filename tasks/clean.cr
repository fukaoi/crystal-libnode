require "./defined"
require "file_utils"

class Clean < LuckyCli::Task
  summary "Full clean up"

  def call
    FileUtils.rm_r("bin") if Dir.exists?("bin")
    FileUtils.rm_r("libnode") if Dir.exists?("libnode")
    system("shards build")
    FileUtils.rm_r("externals") if Dir.exists?("externals")
    success("Full clean up")
  rescue e : Exception
    failed(e.to_s)
  end
end
