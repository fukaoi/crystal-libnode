require "../spec_helper"

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

describe npm("stellar-sdk") do
  it "Get transaction data" do
    node = Node::Js.new
    node.eval(
      <<-CMD
      const stellar = require('stellar-sdk');console.log(stellar);
      const server = new stellar.Server('https://horizon.stellar.org');
    CMD
    )

    node.eval(
      <<-CMD
      server.transactions().forAccount('GA7MC2WZT2RG7LOD7GA4MJ2CQ35ODPZKG2QXZT5O6K3F4642YG3CZP6C').call().then(
      function(page) {
        console.log('Page 1: ');
        console.log(page.records);
        return page.next();
      }).then
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

describe npm("mathjs") do
  it "Calc round" do
    node = Node::Js.new
    res = node.eval(
      <<-CMD
        const math = require('mathjs'); 
        math.round(math.e, 3);
      CMD
    )
    res.should eq "2.718"
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

def npm(page_name : String) : Void
  system("cd /tmp/;npm install #{page_name}")
end
