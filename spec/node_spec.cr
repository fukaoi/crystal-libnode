require "./spec_helper"

describe node = Node::Js.new do
  it "Non local exit success version" do
    res = node.eval(
    <<-CMD
    function main() {
      try {
        throw {result: "test"}
      } catch(tag) {
        if (tag.result === undefined) {
          return {error: tag};
        }
        return tag.result;
      }
    }
    main()
    CMD
    )
    res.should eq "test"
  end

  it "Non local exit error version" do
    res = node.eval(
    <<-CMD
    function main() {
      try {
        throw new Error('raise error!')
      } catch(tag) {
        if (tag.result === undefined) {
          return {error: tag};
        }
        return tag.result;
      }
    }
    main()
    CMD
    )
    res.should eq "[object Object]"
  end

  it "setTimeout" do
    res = node.eval("
      function main() {              
        setTimeout(() => {console.log('Timeout');}, 1);
      }
      main();
    ")
  end

  it "Throw exception catch" do
    res = node.eval("
      const fn = (n) => {
        try {
          if (n < 10) {
            throw new Error('Too small number');
          }
          return true;
        } catch(e) {
          return false;
        }  
      }
      fn(1);
    ")
  end

  it "Throw exception catch. return string message" do
    res = node.eval("
      const fn = (n) => {
        try {
          if (n < 10) {
            throw new Error('Too small number');
          }
          return true;
        } catch(e) {
          console.error(e);
          return e.message;
        }  
      }
      fn(1);
    ")
  end
  

  it "await/async" do
    res = node.eval("
      const calc = (n) => {
        setTimeout((num) => { return num * 9}, 1);    
      };              
      function async main(n) {
        const nn = await calc(n);
        return nn + 10;
      }
      main(10);
    ")
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
