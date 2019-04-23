module Node::NonLocalExit
  extend self

  def return(result : String)
    <<-CMD
      throw result: '#{result}')
    CMD
  end

  def surround(source : String)
    <<-CMD
    try {
      #{source}
    } catch(e) {
      if (e instanceof Error) {
        console.log('Exception !!');
        return {error: e};
      }     
      console.log('Result !!');
      return e.result;
    }
    CMD
  end
end
