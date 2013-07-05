#!/usr/bin/env ruby
require 'gli'
require 'douban.fm'
require 'douban.fm.d'

include GLI::App

program_desc 'download your favorites songs in douban.fm'

version DoubanFMD::VERSION

desc 'Show verbose information'
switch [:v,:verbose]

desc 'douban.fm account name, normally an email address'
default_value ENV['douban_user']||'ENV["douban_user"]'
arg_name 'user'
flag [:u,:user]

desc 'douban.fm password'
default_value ENV['douban_password']||'ENV["douban_password"]'
arg_name 'password'
flag [:p,:password]

desc 'List your favorites songs from douban.fm'
command :list do |c|
  c.action do |global_options,options,args|

    if global_options[:verbose]
      logger = DoubanFM::ConsoleLogger.new
    else
      logger = DoubanFM::DummyLogger.new
    end

    @douban_fm = DoubanFM::DoubanFM.new(logger, global_options[:user], global_options[:password])
    @douban_fm.login
    @douban_fm.fetch_liked_songs(100)
    @douban_fm.liked_songs['songs'].each_with_index do |song, index|
      puts "#{index}#{' '*(4 - index.to_s.length)}#{song['title']} - #{song['artist']}"
    end

    # If you have any errors, just raise them
    # raise "that command made no sense"


  end
end

desc 'Download all your favorites from douban.fm, or specify a song to download'
command :download do |c|
  c.desc "download a single song"
  c.switch [:s,:singleMode]

  c.desc  'title of the song'
  c.arg_name 'title'
  c.flag [:t,:title]

  c.desc 'artist of the song'
  c.arg_name 'artist'
  c.flag [:a,:artist]

  c.action do |global_options,options,args|
    if global_options[:verbose]
      logger = DoubanFM::ConsoleLogger.new
    else
      logger = DoubanFM::DummyLogger.new
    end

    if options[:singleMode]
      help_now!("title is required") if options[:title].nil?
      @douban_fmd = DoubanFMD::DoubanFMDBaidu.new(logger) #TODO: support specify download distr path
      result = @douban_fmd.download(options[:title],options[:artist])
      puts "You have it now: #{result}"
    end
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
