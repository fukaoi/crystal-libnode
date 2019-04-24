module Node
  class Pipe
    def initialize(@mkfifo_path : String = "/tmp")
      create_mkfifo
    end

    def return_to_cr(result : String)
      to_pipe(result, "result")
    end

    def throw_to_cr(exception : String)
      to_pipe(exception, "error")
    end

    private def to_pipe(json_str : String, key : String)
      <<-CMD
        const exec = require('child_process').exec;
        const json = JSON.stringify(JSON.stringify({#{key}: #{json_str}}));
        exec("echo " + json + " > ", function(err, stdout, stderr){
          console.err(err)
        });
      CMD
    end

    private def create_mkfifo
      random_num = Random.rand(10 ** 10)
      unless system("mkfifo #{@mkfifo_path}/cr-node-#{random_num}")
        raise CrNodeException.new("Failed create mkfifo")
      end
    end
  end
end
