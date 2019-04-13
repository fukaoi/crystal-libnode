require "../spec_helper"

def npm(page_name : String) : Void
  system("cd /tmp/;./bin/node-v10.0.0/bin/npm install #{page_name}")
end
