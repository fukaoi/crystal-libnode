require "../spec_helper"

describe node = Node::Js.new do
  it "Call `return` method" do
    res = Node::NonLocalExit.return("true") 
    res.should eq "throw new Error(JSON.parse(JSON.stringify(return: \"true\")))"
  end
end

