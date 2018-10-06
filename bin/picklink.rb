#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-
#
# Rubygem `Nokogiri' is required.
# You can install the gem:
#
# <tt>gem install nokogiri</tt>
#

require 'net/http'
require 'uri'
require 'optparse'
require 'rubygems'
require 'nokogiri'


SCRIPT_VERSION = "1.3.0"
A_HREF     = :a_href
IMG_SRC    = :img_src
BACKGROUND = :background


class ContentGetter
  def initialize(host, path, options)
    @host = host
    @path = path
    @options = options
    if host
      @url_base = "http://#{@host.address}:#{@host.port}#{dirname(@path)}/"
    end
  end

  def get
    url = "http://#{@host.address}:#{@host.port}#{@path}"
    $stderr.puts "getting: #{url}" if @options[:verbose]
    response = @host.start {|http| http.get(@path) }
    raise "Unwelcome response: code=#{response.code}; url=#{url}" unless response.code == "200"
    @content = response.body
  end

  def set_content(content)
    @content = content
    self
  end

  def pick_link
    root = Nokogiri::HTML(@content).root
    links = nil
    case @options[:re]
    when A_HREF
      links = root.search("a").map{|a| a["href"]}
    when IMG_SRC
      links = root.search("img").map{|i| i["src"]}
    end
    links = links.select do |l|
      if l.nil?
        false
      else
        type = l.scan(/[^.]+\z/)[0]
        @options[:types].include?(type)
      end
    end.map do |l|
      unless /\Ahttps?:/ =~ l then @url_base + l else l end
    end

    links
  end

  def content
    @content
  end

  def included_type?(file, types)
    ext = File.extname(file).tr(".", "")
    types.include?(ext)
  end

  def dirname(path)
    /\/[^\/]*\z/.match(path).pre_match
  end
end

def err_exit(msg)
  $stderr.print msg
  exit
end


options = { :re => A_HREF,
            :types => ["html","htm"],
            :recur => false,
            :uniq => false,
            :dump => false,
            :verbose => false,
            :ignore_error => false
          }

psr = OptionParser.new
psr.banner =<<EOB
Pick out hyper-links in specified web page.
Usage: #{psr.program_name} [option] URL
EOB
psr.on('-a', '--a-href', %q[pick out <a href="..."> (default)]){options[:re] = A_HREF}
psr.on('-i', '--img-src', %q[pick out <img src="...">]){options[:re] = IMG_SRC}
#psr.on('-b', '--background', %q[pick out background="..."]){options[:re] = BACKGROUND}
psr.on('-t', '--type=TYPES', String, 'specify file types(comma-separated. default is html,htm).'){|v|
  options[:types] = v.split(",").map{|i| i.downcase}
}
psr.on('--type-image', 'same as `-t jpg,jpeg,png\'.'){|v| options[:types] = ["jpg", "jpeg", "png"]}
psr.on('--type-archive', 'same as `-t lzh,zip\'.'){|v| options[:types] = ["lzh", "zip"]}
psr.on('-u', '--uniq', %q[uniq url.]){options[:uniq] = true}
psr.on('-d', '--dump', %q[dump html source.]){options[:dump] = true}
psr.on('-V', '--verbose', %q[verbose message.]){options[:verbose] = true}
psr.on('-I', '--ignore-error', %q[ignore error.]){options[:ignoerror] = true}
psr.on('-f', '--input-file=FILE', String, %q[input from file.]){|v| options[:input_file] = v}
psr.on_tail('-v', '--version', %q[show version.]){
  puts "#{psr.program_name} v.#{SCRIPT_VERSION}"
  exit
}
psr.on_tail('-h', '--help', %q[show this message.]){puts "#{psr}"; exit}
begin
  psr.parse!
rescue OptionParser::InvalidOption => err
  err_exit(err.message)
end

unless options[:input_file]
  u = URI.parse(ARGV.shift)
  host = u.host
  port = u.port || 80
  path = u.path
  proxy = ENV['http_proxy'] || ENV['http-proxy']
  if proxy
    prxy = URI.parse(proxy)
    proxy_host = prxy.host
    proxy_port = prxy.port
  else
    proxy_host = nil
    proxy_port = nil
  end
end

begin
  if options[:input_file]
    g = ContentGetter.new(nil, nil, options)
    g.set_content(File.open(options[:input_file]){|f| f.read})
  else
    h = Net::HTTP.new(host, port, proxy_host, proxy_port)
    g = ContentGetter.new(h, path, options)
    g.get
    if options[:dump]                          # dump html source.
      print g.content
      exit
    end
  end
  links = g.pick_link
  links.sort!.uniq! if options[:uniq]
  links.each { |l| puts l }
rescue => err
  $stderr.puts err.message
end

