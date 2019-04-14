require "./defined"

class AllBuild < LuckyCli::Task
  summary "All build task"

  def call
    BuildNode.new.call
    BuildLibnode.new.call
    BuildCrystal.new.call
    success("All build done")
  end
end


