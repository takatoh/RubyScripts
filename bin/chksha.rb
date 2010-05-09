#!ruby
#
#  Check/Make SHA256 hash.
#

require 'digest/sha2'
require 'optparse'


def mksha256(file)
  Digest::SHA256.hexdigest(File.open(file, 'rb'){|f| f.read})
end

def chksha256(file, hash)
  mksha256(file) == hash
end


options = { :task => :check }
ARGV.options do |opt|
  opt.banner = <<-EOM
#{opt.program_name}  -  Check/Make SHA256 hash.

Usage: #{opt.program_name} [-c] hashfile
       #{opt.program_name} -m [-f] [-s] file [file..]

  EOM
  opt.on('-c', '--check', 'Check SHA256 hash(default).'){ options[:task] = :check }
  opt.on('-m', '--make', 'Make SHA256 hash.'){ options[:task] = :make }
  opt.on('-f', '--with-filename', 'Print file name.'){ options[:filename] = true }
  opt.on('-s', '--same-name-as-file', 'Output to same-name-as-file.sha256.'){
    options[:sameas] = true
  }
  opt.parse!
end

case options[:task]
when :make
  ARGV.each do |file|
    begin
      r = mksha256(file)
      r += "\t#{file}" if options[:filename]
      if options[:sameas]
        File.open("#{file}.sha256", "w"){ |f| f.print r }
      else
        print r + "\n"
      end
    rescue => err
      $stderr.print "Not exist:  #{file}\n"
    end
  end
when :check
  ARGV.each do |hashfile|
    begin
      File.foreach(hashfile) do |hf|
        hash, file = hf.chomp.split("\t")
        file = hashfile.sub(/\.sha256\z/i, "") unless file
        if chksha256(file, hash)
          print "valid:      #{file}\n"
        else
          print "invalid:    #{file}\n"
        end
      end
    rescue => err
      $stderr.print "Not exist:  #{file}\n"
    end
  end
end

