require "./defined"
require "file_utils"

class BuildNode < LuckyCli::Task
  summary "Build Node.js source. Need to exec before `lucky build`"
  CUSTOM_NPM_DIR = "bin/node-#{NODE_VERSION}"
  
  def initialize
    FileUtils.mkdir(EXTERNAL_DIR) unless Dir.exists?(EXTERNAL_DIR)
  end

  def call
    git_clone_tag
    # create custom node, npm binary
    install_custom_node_npm
    replace_path_innpm

    # create libnode.a shared objectj
    # copy_patch_files
    # build_nodejs  # create libnode.a shared object
    success("Build done")
  rescue e : Exception
    failed(e.to_s)
  end

  private def install_custom_node_npm
    FileUtils.mkdir(CUSTOM_NPM_DIR) unless Dir.exists?(CUSTOM_NPM_DIR)
    build_nodejs("--prefix=#{ENV["PWD"]}/#{CUSTOM_NPM_DIR}")  # create node binary
    system("cd #{NODEJS_SOURCE_DIR};make install")
    FileUtils.cp("#{NODEJS_SOURCE_DIR}/node", "#{CUSTOM_NPM_DIR}/bin/")
  end

  private def replace_path_innpm
    npm_path = "#{CUSTOM_NPM_DIR}/bin/npm"
    body = File.read(npm_path).gsub("/usr/bin/env node","#{CUSTOM_NPM_DIR}/bin/node")
    File.write(npm_path, body)
    # dry run 
    system("LD_LIBRAY_PATH=#{CUSTOM_NPM_DIR}/lib #{CUSTOM_NPM_DIR}/bin/node #{CUSTOM_NPM_DIR}/bin/npm")
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
    unless Dir.exists?("#{EXTERNAL_DIR}/node")
    	status |= system("cd ./#{EXTERNAL_DIR};git clone git@github.com:nodejs/node.git")
    	status |= system("cd ./#{EXTERNAL_DIR}/node;git checkout #{NODE_VERSION}")
    else 
      status |= system("cd ./#{EXTERNAL_DIR}/node;git reset --hard")
    end
    raise Exception.new("Failed git clone") unless status
  end
end
