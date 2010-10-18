# -*- encoding: utf-8 -*-
#
# sweep.rb - Sweep files in the directory.
#

require 'pathname'
require 'fileutils'
require 'date'
require 'optparse'


SCRIPT_VERSION = "0.2.2"

class FileSweeper
  IMAGE_TYPES = %w(.jpg .jpeg .png .bmp .gif)

  def initialize(dir, opts = {})
    @dir = Pathname.new(dir)
    @options = opts
    set_conds
  end

  def sweep
    sweep_files
    sweep_directories
  end


  private

  def set_conds
    @conds = []
    @conds << lambda{|f| true} if @options[:all_types]
    if @options[:types]
      @conds << lambda{|f| @options[:types].include?(f.extname.downcase)}
    end
    if @options[:excerpt_types]
      @conds << lambda{|f| !(@options[:excerpt_types].include?(f.extname.downcase))}
    end
    @conds << lambda{|f| not_image?(f)} if @options[:not_image]
    @conds << lambda do |f|
      t = File.mtime(f)
      @options[:distance] < Date.today - Date.new(t.year, t.month, t.day)
    end if @options[:distance]
  end

  def sweep_files
    @dir.children.select{|c| c.file?}.each do |c|
      if match?(c)
        if @options[:dry_run]
          puts c
        else
          FileUtils.rm(c)
          puts "FILE: #{c}"
        end
      end
    end
  end

  def sweep_directories
    @dir.children.select{|c| c.directory?}.each do |c|
      FileSweeper.new(c, @options).sweep
      if @options[:empty_dir] && c.children.empty?
        c.rmdir
        puts "DIR:  #{c}"
      end
    end
  end

  def match?(p)
    @conds.empty? ? false : @conds.all?{|c| c.call(p)}
  end

  def not_image?(p)
    !(IMAGE_TYPES.include?(p.extname.downcase))
  end
end   # of FileSweeper


options = {}
opts = OptionParser.new
opts.banner =<<EOB
#{opts.program_name} - Sweep files in the directory.
Usage: #{opts.program_name} [option] DIR
EOB
opts.on('-d', '--dry-run', 'dry running'){|v| options[:dry_run] = true}
opts.on('-t', '--types=TYPES', 'remove specified types(comma separated)') do |v|
  options[:types] = v.split(",").map{|t| t.downcase!; t[0,1] == "." ? t : "." + t}
end
opts.on('-a', '--all-types', 'remove all types'){|v| options[:all_types] = true}
opts.on('-e', '--excerpt-types=TYPES', 'excerpt specified types(comma separated)') do |v|
  options[:excerpt_types] = v.split(",").map{|t| t.downcase!; t[0,1] == "." ? t : "." + t}
end
opts.on('--not-image', "excerpt following types: #{FileSweeper::IMAGE_TYPES.join(",")}") do |v|
  options[:not_image] = true
end
opts.on('-T', '--time-distance=N', "older than N days ago") do |v|
  options[:distance] = v.to_i
end
opts.on('--empty-dir', 'remove empty directories'){|v| options[:empty_dir] = true}
opts.on_tail('-h', '--help', 'show this message'){|v| puts opts; exit}
opts.on_tail('-v', '--version', 'show version'){|v| puts SCRIPT_VERSION; exit}
opts.parse!

dir = Pathname.new(ARGV.shift)
sweeper = FileSweeper.new(dir, options)
sweeper.sweep

