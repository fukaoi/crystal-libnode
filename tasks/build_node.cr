require "./defined"
require "file_utils"

class BuildNode < LuckyCli::Task
  summary "Build Node.js source. Need to exec before `lucky build`"

  def call
    FileUtils.mkdir(EXTERNAL_DIR) unless Dir.exists?(EXTERNAL_DIR)
    git_clone_tag
    FileUtils.mkdir("./bin/node-#{LIBNODE_VERSION}") unless Dir.exists?("./bin/node-#{LIBNODE_VERSION}")
    build_nodejs("--prefix=#{ENV["PWD"]}/bin/node-#{LIBNODE_VERSION}")  # create node binary
    system("cd #{NODEJS_SOURCE_DIR};make install")
    FileUtils.cp("#{NODEJS_SOURCE_DIR}/node", "./bin/node-#{LIBNODE_VERSION}/bin/")
    system("sed -e '1d' ./bin/node-#{LIBNODE_VERSION}/bin/npm > ./bin/node-#{LIBNODE_VERSION}/bin/npm") 
    system("sed -i '1s/^/#!./node\n/' ./bin/node-#{LIBNODE_VERSION}/bin/npm")
    system("export LD_LIBRAY_PATH")

    # copy_patch_files
    # build_nodejs  # create libnode.a shared object
    success("Build done")
  rescue e : Exception
    failed(e.to_s)
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
