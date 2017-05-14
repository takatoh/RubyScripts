#!/usr/bin/env ruby
# encoding: utf-8

require 'pathname'

dir = Pathname.new(ARGV.shift)
target = /require .+#{ARGV.shift}/

dir.find do |f|
  if f.file? && f.extname == ".rb"
    f.each_line do |line|
      print "#{f}: #{line}" if target =~ line
    end
  end
end

