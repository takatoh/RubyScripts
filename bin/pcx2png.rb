#!/usr/bin/env ruby
# encoding: utf-8


require 'find'
require 'optparse'
require 'fileutils'


def pcx?(file)
  File.file?(file) && File.extname(file).downcase == ".pcx"
end

def pcx2png(pcx, png)
  system("convert #{pcx} #{png}")
  if @options[:keep_time]
    stat = File.stat(pcx)
    File.utime(stat.atime, stat.mtime, png)
  end
  if @options[:no_keep]
    FileUtils.rm(pcx)
  end
end


@options = {
  recursive: false,
  no_keep:   false,
  keep_time: false
}
opts = OptionParser.new
opts.banner = <<EOB
Usage: #{opts.program_name} [options] <target>
EOB
opts.on("-r", "--recursive", "Recursive mode."){|v| @options[:recursive] = true }
opts.on("--no-keep", "Remove .pcx file."){|v| @options[:no_keep] = true }
opts.on("--keep-time", "Keep timestamp."){|v| @options[:keep_time] = true }
opts.on_tail("-h", "--help", "Show this message."){|v| puts opts; exit }
opts.parse!


target = ARGV.shift
if pcx?(target)
  pcx = target
  png = pcx.sub(File.extname(pcx), ".png")
  puts "#{pcx} => #{png}"
  pcx2png(pcx, png)
elsif File.directory?(target)
  if @options[:recursive]
    Find.find(target) do |f|
      if pcx?(f)
        png = f.sub(File.extname(f), ".png")
        puts "#{f} => #{png}"
        pcx2png(f, png)
      end
    end
  else
    Dir.glob("#{target}/*") do |f|
      if pcx?(f)
        png = f.sub(File.extname(f), ".png")
        puts "#{f} => #{png}"
        pcx2png(f, png)
      end
    end
  end
else
  puts "target must be .pcx file or directory."
  puts opts
end
