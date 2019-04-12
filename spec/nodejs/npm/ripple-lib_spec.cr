require "../npm_spec.cr"

describe npm("ripple-lib") do
  it "Get account info" do
    node = Node::Js.new
    node.eval(
    <<-CMD
      'use strict';

      const RippleAPI = require('ripple-lib').RippleAPI;
      const api = new RippleAPI({
        server: 'wss://s2.ripple.com:443'
      });
    CMD
    )

    node.eval(
    <<-CMD
      api.connect().then(() => {
        const myAddress = 'rJumr5e1HwiuV543H7bqixhtFreChWTaHH';
        console.log('getting account info for', myAddress);
        return api.getAccountInfo(myAddress);
      }).then(info => {
        console.log(info)
        console.log('getAccountInfo done')
      }).then(() =>{
        return api.disconnect()
      }).then(() => {
        console.log('done and disconnected')
      }).catch(console.error)
    CMD
    )
  end
end





