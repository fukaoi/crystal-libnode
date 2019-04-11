require "../../src/nodejs.cr"

def crystal_main(npm_name)
  unless npm_name
    puts("Please set npm name at argument")
    return
  end
  puts "Executable main method..."
  node = Node::Js.new
  node.eval(
    <<-CMD
    const npm = require("#{npm_name}");\
    console.log(npm);
  CMD
  )
end

crystal_main(ARGV[0])
