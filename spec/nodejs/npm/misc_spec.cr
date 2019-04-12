require "../npm_spec.cr"

describe npm("bitcoin-core") do
  it "Get transaction data" do
    node = Node::Js.new
    node.eval(
      <<-CMD
      const bit = require('bitcoin-core');
      console.log(bit);
    CMD
    )
  end
end

describe npm("web3") do
  it "web3" do
    node = Node::Js.new
    node.eval(
      <<-CMD
        const web3 = require('web3'); 
        console.log(web3);
      CMD
    )
  end
end

describe npm("solc") do
  it "solc" do
    node = Node::Js.new
    node.eval(
      <<-CMD
        const sc = require('solc'); 
        console.log(sc);
      CMD
    )
  end
end

describe npm("jquery") do
  it "Create object" do
    node = Node::Js.new
    node.eval(
      <<-CMD
      const jquery = require('jquery');
      console.log(jquery);
    CMD
    )
  end
end

describe npm("underscore") do
  it "Create object" do
    node = Node::Js.new
    node.eval(
      <<-CMD
      const us = require('underscore');
      console.log(us);
    CMD
    )
  end
end

describe npm("express") do
  it "Create object" do
    node = Node::Js.new
    node.eval(
      <<-CMD
      const ex = require('express');
      console.log(ex);
    CMD
    )
  end
end
