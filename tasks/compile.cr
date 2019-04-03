require "./defined"
require "file_utils"

class NodeBuild < LuckyCli::Task
  summary "Build Node.js source. Need to exec before `lucky build`"

  def call
    FileUtils.mkdir(EXTERNAL_DIR) unless Dir.exists?(EXTERNAL_DIR)
    unless Dir.exists?(NODEJS_SOURCE_DIR)
      git_clone_tag
      build_nodejs
      success("Build done")
    else
      success("Build failed")
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
