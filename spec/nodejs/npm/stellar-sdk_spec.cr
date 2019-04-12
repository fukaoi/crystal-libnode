require "../npm_spec.cr"

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
