require "./defined"
require "file_utils"

class Clean < LuckyCli::Task
  summary "clean up bin/, libnode/ directory"

  def call
    FileUtils.rm_r("bin") if Dir.exists?("bin")
    FileUtils.rm_r("libnode") if Dir.exists?("libnode")
    system("shards build")
    success("Clean up")
  rescue e : Exception
    failed(e.to_s)
  end
end

class FullClean < LuckyCli::Task
  summary "Full clean up"

  def call
    Clean.new.call
    FileUtils.rm_r("externals") if Dir.exists?("externals")
    success("Full clean up")
  rescue e : Exception
    failed(e.to_s)
  end
end
