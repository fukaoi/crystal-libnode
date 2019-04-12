require "../npm_spec.cr"

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
