require "./defined"
require "file_utils"

class BuildCrystal < LuckyCli::Task
  summary "Build Crystal program files"

  def call
    mkdir_need_dir
    copy_libnode
    success("Crystal build done")
  rescue e : Exception
    failed(e.to_s)
  end

  private def mkdir_need_dir
    FileUtils.mkdir(LIBRARY_DIR) unless Dir.exists?(LIBRARY_DIR)
    FileUtils.mkdir("bin") unless Dir.exists?("bin")
  end

  private def copy_libnode
    FileUtils.cp(
      # "#{NODEJS_SOURCE_DIR}/out/Release/lib.target/libnode.so.#{LIBNODE_VERSION}",
      "#{NODEJS_SOURCE_DIR}/out/Debug/lib.target/libnode.so.#{LIBNODE_VERSION}",
      "#{LIBRARY_DIR}/libnode.so.#{LIBNODE_VERSION}"
    )
  end
end
