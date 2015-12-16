#!/usr/bin/env ruby
# encoding: utf-8


require 'find'


class DirNode

  attr_reader :name

  def initialize(name, root = false)
    @name = name
    @root = root
    @children = []
  end

  def self.read(dir)
    name = dir.split("/")[0]
    root = DirNode.new(name, true)
    Find.find(dir) do |f|
      if File.directory?(f) && f != dir.to_s
        root.add(f)
      end
    end
    root
  end

  def add(path)
    m = path.to_s.split("/")
    if m.size > 1
      ch_name = m[1]
      ch_path = m[1..-1].join("/")
      ch = if @children.map{|c| c.name }.include?(ch_name)
        @children.select{|c| c.name == ch_name }.first
      else
        c = DirNode.new(ch_path)
        @children << c
        c
      end
      if m.size > 2
        ch.add(ch_path)
      end
    end
    self
  end

  def to_tree(ind = 0)
    result = ""
    result << " " * ind + "#{@name}\n"
    result << @children.map do |ch|
      ch.to_tree(ind + 2)
    end.join("")
    result
  end

end   # of class DirNode


dir = ARGV.shift
root = DirNode.read(dir)
print root.to_tree
