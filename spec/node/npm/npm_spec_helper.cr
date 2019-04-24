require "../../spec_helper.cr"

def npm(page_name : String) : Void
  Node::Npm.init
  unless Node::Npm.is_installed?(page_name)
    system("cd /tmp/;#{Node::Npm.path} install #{page_name}")
  end
end
