#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-


require 'aws'
require 'yaml'
require 'fileutils'
require 'optparse'


SCRIPT_VERSION = "0.1.0"

def main
  parser = OptionParser.new
  parser.banner = <<-EndBanner
Usage: #{parser.program_name} <subcommand> [options] [args]

Subcommands:
    upload      Upload file.
    download    Download object.
    list        List objects.
    delete      Delete object.

Global Options:
  EndBanner
  parser.on('-v', '--version', 'Show version.') {
    puts "v#{SCRIPT_VERSION}"
    exit 0
  }
  parser.on('-h', '--help', 'Show this message.') {
    puts parser.help
    exit 0
  }

  subcommands = {}
  subcommands['list']     = ListCommand.new
  subcommands['upload']   = UploadCommand.new
  subcommands['download'] = DownloadCommand.new
  subcommands['delete']   = DeleteCommand.new
  begin
    parser.order!
    if ARGV.empty?
      $stderr.puts 'no sub-command given'
      $stderr.puts parser.help
      exit 1
    end
    name = ARGV.shift
    cmd = subcommands[name] or error "no such sub-command: #{name}"
  rescue OptionParser::ParseError => err
    $stderr.puts err.message
    $stderr.puts parser.help
    exit 1
  end
  begin
    cmd.parse(ARGV)
  rescue OptionParser::ParseError => err
    $stderr.puts err.message
    $stderr.puts cmd.help
    exit 1
  end
  cmd.exec(ARGV)
end

def error(msg)
  $stderr.puts "#{File.basename($0, '.*')}: error: #{msg}"
  exit 1
end


class Subcommand

  def parse(argv)
    @parser.parse(argv)
  end

  def help
    @parser.help
  end

  def get_bucket
    config_file = File.join(ENV["HOME"], "aws-config.yaml")
    config = YAML.load_file(config_file)
    s3 = AWS::S3.new(
      :access_key_id     => config["ACCESS_KEY_ID"],
      :secret_access_key => config["SECRET_ACCESS_KEY"])
    s3.buckets[config["BUCKET"]]
  end

end   # class Subcommand


class ListCommand < Subcommand

  def initialize
    @options = {}
    @parser = OptionParser.new
    @parser.banner =<<EOB
#{@parser.program_name} list - List objects in bucket.
Usage: #{@parser.program_name} list
EOB
  end

  def exec(argv)
    bucket = get_bucket
    bucket.objects.each do |obj|
      puts obj.key
    end
  end

end   # of class ListCommand


class UploadCommand < Subcommand

  def initialize
    @options = {}
    @parser = OptionParser.new
    @parser.banner =<<EOB
#{@parser.program_name} upload - Upload file to bucket.
Usage: #{@parser.program_name} upload <file> <key>
EOB
  end

  def exec(argv)
    file = argv.shift
    key = argv.shift
    content = File.open(file, "rb"){|f| f.read}

    bucket = get_bucket
    obj = bucket.objects[key]
    if obj.exists?
      puts "Error: Object already exists: #{key}."
      exit 0
    end
    obj.write(content, :acl => :public_read)
  end

end   # of class UploadCommand


class DownloadCommand < Subcommand

  def initialize
    @options = {}
    @parser = OptionParser.new
    @parser.banner =<<EOB
#{@parser.program_name} download - Download file from bucket.
Usage: #{@parser.program_name} download <key>
EOB
  end

  def exec(argv)
    bucket = get_bucket
    key = argv.shift
    obj = bucket.objects[key]
    unless obj.exists?
      puts "Error: No such object: #{key}"
      exit 0
    end
    file = key
    if File.dirname(file) != "."
      FileUtils.mkdir_p(File.dirname(file))
    end
    File.open(file, "wb") do |f|
      obj.read do |chunk|
        f.write(chunk)
      end
    end
  end

end   # of class DownloadCommand


class DeleteCommand < Subcommand

  def initialize
    @options = {}
    @parser = OptionParser.new
    @parser.banner =<<EOB
#{@parser.program_name} delete - Delete key from bucket.
Usage: #{@parser.program_name} delete <key>
EOB
  end

  def exec(argv)
    bucket = get_bucket
    key = argv.shift
    obj = bucket.objects[key]
    unless obj.exists?
      puts "No such object: #{key}"
      exit 0
    end
    obj.delete
  end

end   # of class DeleteCommand


main
