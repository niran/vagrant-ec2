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

  transfer_paths = ["cookbooks"]
  transfer_paths.reject!{|path| not File.exists?(path)}
  open('transfer_paths', 'w'){|f| f.puts transfer_paths}

  `tar czf cookbooks.tgz --files-from transfer_paths 2> /dev/null`
  `rm transfer_paths`
end
