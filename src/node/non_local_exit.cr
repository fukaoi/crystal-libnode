module Node::NonLocalExit
  extend self

  def return(result : String)
    <<-CMD
    throw new Error(JSON.parse(JSON.stringify(result: '#{result}')))
    CMD
  end

  def surround(source : String)
    <<-CMD
    try {
      #{source}
    } catch(tag) {
      if (tag.result !== undefined) {
        console.log('try catch: Exception');
        return tag;
      }     
      console.log('try catch: result');
      return tag.result;
    }
    CMD
  end
  def surround(source : String)
    <<-CMD
    try {
      #{source}
    } catch(tag) {
      if (tag.result !== undefined) {
        console.log('try catch: Exception');
        return tag;
      }     
      console.log('try catch: result');
      return tag.result;
    }
    CMD
  end
end
