require "./defined"
require "file_utils"

class BuildNode < LuckyCli::Task
  summary "Build Node.js source. Need to exec before `lucky build`"

  def call
    FileUtils.mkdir(EXTERNAL_DIR) unless Dir.exists?(EXTERNAL_DIR)
    git_clone_tag
    build_nodejs  # create node binary
    system("make install")
    extract_node_binary
    copy_patch_files
    build_nodejs  # create libnode.a shared object
    success("Build done")
  rescue e : Exception
    failed(e.to_s)
  end

  private def extract_node_binary
    FileUtils.cp("#{NODEJS_SOURCE_DIR}/out/Debug/node", "#{NODEJS_SOURCE_DIR}/out/Debug/node_binary")
  end

  private def copy_patch_files
    status = false
    status |= system("cp #{CPULS_SOURCE_DIR}/node_lib.h #{NODEJS_SOURCE_DIR}/src/")
    status |= system("cp #{CPULS_SOURCE_DIR}/#{NODE_VERSION}_#{LIBNODE_VERSION}/node.cc #{NODEJS_SOURCE_DIR}/src/")
    status |= system("cp #{CPULS_SOURCE_DIR}/#{NODE_VERSION}_#{LIBNODE_VERSION}/node.js #{NODEJS_SOURCE_DIR}/lib/internal/bootstrap/")
    raise Exception.new("Failed copy patch files") unless status
  end

  private def git_clone_tag
    status = false
    status |= system("cd ./#{EXTERNAL_DIR};git clone git@github.com:nodejs/node.git")
    status |= system("cd ./#{EXTERNAL_DIR}/node;git checkout #{NODE_VERSION}")
    raise Exception.new("Failed git clone") unless status
  end
end
