require "../spec_helper"

def npm(page_name : String) : Void
  system("cd /tmp/;#{Node::Npm.path} install #{page_name}")
end
