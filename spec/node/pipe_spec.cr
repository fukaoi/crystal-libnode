require "../spec_helper"

describe Node::Pipe do
  Spec.after_each do
    Dir.glob("/tmp/cr-node-*") do |file|
      File.delete(file)
    end
  end

  it "Initialize" do
    pipe = Node::Pipe.new
    Dir.glob("/tmp/cr-node-*").empty?.should be_false
  end

  it "Call to `return_to_cr` method" do
    pipe = Node::Pipe.new
    res = pipe.return_to_cr("{\"data\":\"dummy\"}")
		res.empty?.should be_false
  end

  it "Call to `throw_to_cr` method" do
    pipe = Node::Pipe.new
    res = pipe.throw_to_cr("throw new Error('Spec')")
		res.empty?.should be_false
  end
end
