require "../spec_helper"

describe node = Node::Js.new do
  it "Call `return` method" do
    expect = <<-CMD
    throw new Error(JSON.parse(JSON.stringify(result: 'true')))
    CMD
    res = Node::NonLocalExit.return("true") 
    res.should eq expect
  end

  it "Call `surround` method" do
    expect = <<-CMD
    try {
      return true
    } catch(tag) {
      if (tag.result == undefined) {
        console.log('try catch: Exception');
        return tag;
      }     
      console.log('try catch: result');
      return tag.result;
    }
    CMD
    res = Node::NonLocalExit.surround("return true") 
    res.should eq expect
  end
end

