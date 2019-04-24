require "./spec_helper"

describe node = Node::Js.new do
  it "Non local exit success version" do
    res = node.eval(
      <<-CMD
    function main() {
      try {
        throw {result: "test"}
      } catch(e) {
        if (e instanceof Error) {
          return {error: e};
        }
        return e.result;
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
      } catch(e) {
        if (e instanceof Error) {
          return {error: e};
        }
        return e.result;
      }
    }
    main()
    CMD
    )
    res.should eq "[object Object]"
  end

  it "setTimeout" do
    res = node.eval(
      <<-CMD
      function main() {              
        setTimeout(() => {console.log('Timeout');}, 1);
      }
      main();
    CMD
    )
  end

  it "await/async" do
    res = node.eval(
      <<-CMD
      function asyncFunction() {
        return new Promise(function (resolve, reject) {
        setTimeout(function () {
            resolve('Async Hello world');
        }, 2000); // 2sec wait;
      });
      }

      asyncFunction().then(function (value) {
        console.log(value);    
      }).catch(function (error) {
        console.log(error);
      });
    CMD
    )
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
