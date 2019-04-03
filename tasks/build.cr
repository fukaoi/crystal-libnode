require "./defined"
require "file_utils"

class Build < LuckyCli::Task
  summary "Build Crystal program files"

  def call
    mkdir_need_dir
    copy_patch_files
    build_nodejs
    copy_libnode
    success("Build done")
  rescue e : Exception
    failed(e.to_s)
  end

  private def mkdir_need_dir
    FileUtils.mkdir(LIBRARY_DIR) unless Dir.exists?(LIBRARY_DIR)
    FileUtils.mkdir("bin") unless Dir.exists?("bin")
  end

  private def copy_patch_files
    status = false
    status |= system("cp #{CPULS_SOURCE_DIR}/#{NODE_VERSION}_#{LIBNODE_VERSION}/node.cc #{NODEJS_SOURCE_DIR}/src/")
    status |= system("cp #{CPULS_SOURCE_DIR}/#{NODE_VERSION}_#{LIBNODE_VERSION}/node.js #{NODEJS_SOURCE_DIR}/lib/internal/bootstrap/")
    raise Exception.new("Failed copy patch files") unless status
  end

  private def copy_libnode
    FileUtils.cp(
      # "#{NODEJS_SOURCE_DIR}/out/Release/lib.target/libnode.so.#{LIBNODE_VERSION}",
      "#{NODEJS_SOURCE_DIR}/out/Debug/lib.target/libnode.so.#{LIBNODE_VERSION}",
      "#{LIBRARY_DIR}/libnode.so.#{LIBNODE_VERSION}"
    )
  end
end
