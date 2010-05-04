#! ruby
# -*- encoding: utf-8 -*-
#
# Print HTTP header.
#
# Rubygem `HTTPClient' is required.
# You can install the gem:
#
# <tt>gem install httpclient</tt>
#

#require 'rubygems'
require 'httpclient'


url = ARGV.shift

clnt = HTTPClient.new
clnt.head(url).header.all.each do |name, value|
  puts "#{name}: #{value}"
end

