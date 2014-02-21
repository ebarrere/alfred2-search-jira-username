#!/usr/bin/env ruby
# encoding: utf-8

$: << File.expand_path(File.dirname(__FILE__))
require 'rubygems' unless defined? Gem # rubygems is only needed in 1.8
require "bundle/bundler/setup"
require "alfred"

Alfred.with_friendly_error do |alfred|
  fb = alfred.feedback
  @path = "~/Documents/work/accretive/jira/"

  # set up logging
  @logger = Logger.new(File.expand_path("~/Library/Logs/Alfred-Workflow.log"))
  @debug = false
  
  File.open(File.expand_path("#{@path}/user_list.csv"), "r") do |file_handle|
    file_handle.each_line do |line|
      line.delete! '"'
      username,fullname,email,timezone,avatarUrl = line.split(',')
      deficon = "icon.png"
      icon = File.expand_path("#{@path}/#{username}.png")
      unless File.file?(icon)
        icon = deficon
      end
      @logger.debug("username: #{username}, fullname: #{fullname}, email: #{email}, timezone: #{timezone}, avatarUrl: #{avatarUrl}") if @debug
      @logger.debug("icon #{icon}") if @debug

      fb.add_item({
        :title        => "#{fullname}",
        :subtitle     => "#{username}",
        :arg          => "[~#{username}]",
        :autocomplete => "#{fullname}",
        :icon         => {:type => "default", :name => "#{icon}"},
        :valid        => "yes",
      })
    end
  end

  if ARGV[0].eql? "failed"
    alfred.with_rescue_feedback = true
    raise Alfred::NoBundleIDError, "Wrong Bundle ID Test!"
  end

  puts fb.to_xml(ARGV)
end