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

describe Node::Npm do
  it "Get npm path" do
    npm_path = Node::Npm.path
    npm_path.empty?.should be_false
  end

  it "Get npm path with argument" do
    npm_path = Node::Npm.path("v10.0.0")
    npm_path.empty?.should be_false
  end

  it "Execute parse node version" do
    node_version = Node::Npm.parse_node_version
    node_version.empty?.should be_false
  end

  it "Execute parse node version with argument" do
    node_version = Node::Npm.parse_node_version("v10.0.0")
    node_version.empty?.should be_false
  end
end
