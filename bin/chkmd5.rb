#!ruby
# -*- encoding: utf-8 -*-
#
#  Check/Make MD5 hash.
#

require 'digest/md5'
require 'optparse'


def mkmd5(file)
  Digest::MD5.hexdigest(File.open(file, 'rb'){|f| f.read})
end

def chkmd5(file, hash)
  mkmd5(file) == hash.downcase
end


options = { :task => :check }
ARGV.options do |opt|
  opt.banner = <<-EOM
#{opt.program_name}  -  Check/Make MD5 hash.

Usage: #{opt.program_name} [-c] hashfile
       #{opt.program_name} [-c] -H HASH file
       #{opt.program_name} -m [-f] [-s] file [file..]

  EOM
  opt.on('-c', '--check', 'Check MD5 hash(default).'){ options[:task] = :check }
  opt.on('-H', '--hash=HASH', 'HASH value to be compared. Argument must be a file name.'){|v|
    options[:hash] = v
  }
  opt.on('-m', '--make', 'Make MD5 hash.'){ options[:task] = :make }
  opt.on('-f', '--with-filename', 'Print file name.'){ options[:filename] = true }
  opt.on('-s', '--same-name-as-file', 'Output to same-name-as-file.md5.'){
    options[:sameas] = true
  }
  opt.on_tail('-h', '--help', 'Show this message.'){ print opt }
  opt.parse!
end

case options[:task]
when :make
  ARGV.each do |file|
    begin
      r = mkmd5(file)
      r += "  #{file}" if options[:filename]
      if options[:sameas]
        File.open("#{file}.md5", "w"){ |f| f.print r }
      else
        print r + "\n"
      end
    rescue => err
      $stderr.print "Not exist:  #{file}\n"
    end
  end
when :check
  if options[:hash]
    file = ARGV.shift
    if chkmd5(file, options[:hash])
      print "valid:      #{file}\n"
    else
      print "invalid:    #{file}\n"
    end
  else
    ARGV.each do |hashfile|
      begin
        File.foreach(hashfile) do |hf|
          hash, file = hf.chomp.split(/\s+/,2)
          file = hashfile.sub(/\.md5\z/i, "") unless file
          if chkmd5(file, hash)
            print "valid:      #{file}\n"
          else
            print "invalid:    #{file}\n"
          end
        end
      rescue => err
        $stderr.print err.message
      end
    end
  end
end

