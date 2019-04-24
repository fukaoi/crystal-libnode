module Node::Pipe
  extend self

  def return_to_cr(result : String)
    <<-CMD
      throw result: '#{result}')
    CMD
  end

  def throw_to_cr(exception)

  end
end
