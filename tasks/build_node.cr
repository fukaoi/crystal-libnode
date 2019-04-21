require "./defined"
require "file_utils"

class BuildNode < LuckyCli::Task
  summary "Create custom node binary. Need to exec before `lucky build`"
  CUSTOM_NPM_DIR = "bin/node-#{NODE_VERSION}"

  def initialize
    FileUtils.mkdir(EXTERNAL_DIR) unless Dir.exists?(EXTERNAL_DIR)
  end

  def call
    git_clone_tag
    install_custom_node_npm
    replace_path_npm
    success("Node build done")
  rescue e : Exception
    failed(e.to_s)
  end

  def git_clone_tag
    status = false
    unless Dir.exists?("#{EXTERNAL_DIR}/node")
      status |= system("cd ./#{EXTERNAL_DIR};git clone git@github.com:nodejs/node.git")
      status |= system("cd ./#{EXTERNAL_DIR}/node;git checkout #{NODE_VERSION}")
    else
      status |= system("cd ./#{EXTERNAL_DIR}/node;git reset --hard")
    end
    raise Exception.new("Failed git clone") unless status
  end

  def copy_patch_files
    status = false
    status |= system("cp #{CPULS_SOURCE_DIR}/node_lib.h #{NODEJS_SOURCE_DIR}/src/")
    status |= system("cp #{CPULS_SOURCE_DIR}/#{NODE_VERSION}_#{LIBNODE_VERSION}/node.cc #{NODEJS_SOURCE_DIR}/src/")
    status |= system("cp #{CPULS_SOURCE_DIR}/#{NODE_VERSION}_#{LIBNODE_VERSION}/node.js #{NODEJS_SOURCE_DIR}/lib/internal/bootstrap/")
    raise Exception.new("Failed copy patch files") unless status
  end

  private def install_custom_node_npm
    FileUtils.mkdir(CUSTOM_NPM_DIR) unless Dir.exists?(CUSTOM_NPM_DIR)
    build_nodejs("--prefix=#{ENV["PWD"]}/#{CUSTOM_NPM_DIR} --debug") # create node binary
    system("cd #{NODEJS_SOURCE_DIR};make install")
    FileUtils.cp("#{NODEJS_SOURCE_DIR}/node", "#{CUSTOM_NPM_DIR}/bin/")
  end

  private def replace_path_npm
    npm_path = "#{CUSTOM_NPM_DIR}/bin/npm"
    body = File.read(npm_path).gsub("/usr/bin/env node", "#{ENV["PWD"]}/#{CUSTOM_NPM_DIR}/bin/node")
    File.write(npm_path, body)
  end
end

class BuildLibnode < BuildNode
  summary "Create libnode.so shared object. Need to exec before `lucky build`"
  CUSTOM_NPM_DIR = "bin/node-#{NODE_VERSION}"

  def call
    git_clone_tag
    copy_patch_files
    build_nodejs("--debug --shared") # create libnode.a shared object
    copy_libnode
    success("Libnode build done")
  end

  private def copy_libnode
    FileUtils.cp(
      # "#{NODEJS_SOURCE_DIR}/out/Release/lib.target/libnode.so.#{LIBNODE_VERSION}",
      "#{NODEJS_SOURCE_DIR}/out/Debug/lib.target/libnode.so.#{LIBNODE_VERSION}",
      "#{LIBRARY_DIR}/libnode.so.#{LIBNODE_VERSION}"
    )
  end
end
