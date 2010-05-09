#
# cf. http://ja.doukaku.org/12/
#

require 'date'

y, m, d = ARGV.map{|arg| arg.to_i }
date = Date.new(y, m, d)
sunday = (date - date.wday)
(1..5).each do |d|
  puts((sunday + d).strftime("%Y-%m-%d %a"))
end

