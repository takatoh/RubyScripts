#!/usr/bin/env ruby
# encoding: utf-8


require 'find'


class DirNode

  attr_reader :path

  def initialize(path, root = false)
    @path = path
    @root = root
    @children = []
  end

  def self.read(dir)
    name = dir.split("/")[0]
    root = DirNode.new(name, true)
    Find.find(dir) do |f|
      if File.directory?(f) && f != dir
        root.add(f)
      end
    end
    root
  end

  def name
    @path.split("/")[-1]
  end

  def add(path)
    path2 = path.sub(/#{@path}\/?/, "")
    unless path2.empty?
      m = path2.split("/")
      ch = if @children.map{|c| c.name }.include?(m[0])
        @children.select{|c| c.name == m[0] }.first
      else
        c = DirNode.new(path)
        @children << c
        c
      end
      ch.add(path)
    end
    self
  end

  def to_tree(ind = 0)
    result = ""
    result << " " * ind + "#{name}\n"
    result << @children.map do |ch|
      ch.to_tree(ind + 2)
    end.join("")
    result
  end

end   # of class DirNode


if __FILE__ == $0
  dir = ARGV.shift
  root = DirNode.read(dir)
  print root.to_tree
end
