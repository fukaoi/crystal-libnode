require "./defined"
require "file_utils"

class Compile < LuckyCli::Task
  banner "Compile Node.js source"

  def call
    FileUtils.mkdir(EXTERNAL_DIR) unless Dir.exists?(EXTERNAL_DIR)
    unless Dir.exists?(NODEJS_SOURCE_DIR)
      git_clone_tag
      build_nodejs
      success("Compiled")
    else
      success("No compile")
    end
  rescue e : Exception
    failed(e.to_s)
  end

  private def git_clone_tag
    status = false
    status |= system("cd ./#{EXTERNAL_DIR};git clone git@github.com:nodejs/node.git")
    status |= system("cd ./#{EXTERNAL_DIR}/node;git checkout #{NODE_VERSION}")
    raise Exception.new("Failed git clone") unless status
  end
end
