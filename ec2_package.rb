#!/usr/bin/env ruby
#Make a tarball of only the recipes called in dna.json
#Takes as an argument the path to a Vagrant VM's folder.
require 'rubygems'
require 'json'

Dir.chdir(ARGV[0]) do
  #run vagrant to parse the `Vagrantfile` and write out `dna.json` and `.cookbooks_path.json`.
  res = `vagrant`
  if $?.exitstatus != 0
    puts res
    exit 1
  end
  cookbooks_path = [JSON.parse(open('.cookbooks_path.json').read)].flatten
  cookbooks_path.reject!{|path| not File.exists?(path)}

  open('cookbook_list', 'w'){|f| f.puts cookbooks_path}

  `tar czf cookbooks.tgz --files-from cookbook_list 2> /dev/null`
  `rm cookbook_list`
end
