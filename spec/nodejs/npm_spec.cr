require "../spec_helper"

def npm(page_name : String) : Void
  system("cd /tmp/;npm install #{page_name}")
end
