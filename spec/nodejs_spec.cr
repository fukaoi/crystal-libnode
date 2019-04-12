require "./spec_helper"

describe node = Node::Js.new do
  it "Evaluate js code" do
    node.eval("
      const data = 1 + 1
      console.log(data)
    ")
  end

  it "Evaluate return js code" do
    res = node.eval("
      const fn = (n) => {
        const data = n + 1;
        return data;
      }
      fn(10);
    ")
    res.should eq "11"
  end
end
