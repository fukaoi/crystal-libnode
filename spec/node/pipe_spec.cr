require "../spec_helper"

describe Node::Pipe do
  Spec.after_each do
    Dir.glob("/tmp/cr-node-*") do |file|
      puts "deleting #{file}"
      File.delete(file)
    end
  end

  it "Initialize" do
    pipe = Node::Pipe.new
    Dir.glob("/tmp/cr-node-*").empty?.should be_false
  end

  it "Initialize by params" do
    pipe = Node::Pipe.new("cr-node-test")
    Dir.glob("/tmp/cr-node-test").empty?.should be_false
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

  it "Call to `parse` method" do
    pipe_file = "cr-node-parse"
    pipe = Node::Pipe.new(pipe_file)

    # ---- mkfifo blocking command
    spawn do
      cmd = "echo '{\"Result\":{\"data\":10}}' > /tmp/#{pipe_file}"  
      system(cmd)
    end
    Fiber.yield
    # ----

    receive_data = pipe.parse
    res = receive_data["data"]
    puts "\n # receive_data: #{receive_data}\n"
    res.should eq 10
  end

  it "Execute return_to_cr in jscode" do
    pipe = Node::Pipe.new("cr-node-spec")
    # ---- Do necessary fork, because mkdfifo need to another process
    Process.fork do
      return_to_cr = pipe.return_to_cr("{data:'dummy'}")
      js = Node::Js.new
      code = <<-CMD
			  function main() {#{return_to_cr}}; main()
		  CMD
      js.eval(code)
    end 
    # ----
    res = pipe.parse
    res["data"].should eq "dummy"
    
  end

  # it "Execute throw_to_cr in jscode" do
    # pipe = Node::Pipe.new("cr-node-spec")
    # p pipe.parse
 
    # # ---- mkfifo blocking command
    # spawn do
      # js = Node::Js.new
      # code = <<-CMD
      # function main() {
        # try {
          # throw new Error('JS spec !!')
        # } catch(e) {               // <- catch a param
      # #{pipe.throw_to_cr("e")} // need to same value of catch a param
        # }
      # }

      # main()
      # CMD
      # p js.eval(code)
    # end
    # Fiber.yield
    # # ----
  # end
end
