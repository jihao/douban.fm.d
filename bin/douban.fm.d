#!/usr/bin/env ruby
require 'gli'
require 'douban.fm.d'

include GLI::App

program_desc 'Describe your application here'

version DoubanFM::VERSION

desc 'Describe some switch here'
switch [:s,:switch]

desc 'Describe some flag here'
default_value 'the default'
arg_name 'The name of the argument'
flag [:f,:flagname]

desc 'Describe list here'
arg_name 'Describe arguments to list here'
command :list do |c|
  c.desc 'Describe a switch to list'
  c.switch :s

  c.desc 'Describe a flag to list'
  c.default_value 'default'
  c.flag :f
  c.action do |global_options,options,args|

    # Your command logic here
     
    # If you have any errors, just raise them
    # raise "that command made no sense"

    puts "list command ran"
  end
end

desc 'Describe download here'
arg_name 'Describe arguments to download here'
command :download do |c|
  c.action do |global_options,options,args|
    puts "download command ran"
  end
end

pre do |global,command,options,args|
  # Pre logic here
  # Return true to proceed; false to abort and not call the
  # chosen command
  # Use skips_pre before a command to skip this block
  # on that command only
  true
end

post do |global,command,options,args|
  # Post logic here
  # Use skips_post before a command to skip this
  # block on that command only
end

on_error do |exception|
  # Error logic here
  # return false to skip default error handling
  true
end

exit run(ARGV)
