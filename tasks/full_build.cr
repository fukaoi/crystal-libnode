require "./defined"

class FullBuild < LuckyCli::Task
  summary "All build task"

  def call
    BuildNode.new.call
    BuildLibnode.new.call
    BuildBridge.new.call
    success("Full build done")
  end
end
