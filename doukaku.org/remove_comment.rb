#
# Remove comment
# cf. http://ja.doukaku.org/17/
#


def remove_comment(str)
  str.gsub(/\/\*.*?(\*\/|\z)/,"")
end


samples = %w( AAA
              AAA/*BBB*/
              AAA/*BBB
              AAA/*BBB*/CCC
              AAA/*BBB/*CCC*/DDD*/EEE
              AAA/a//*BB*B**/CCC
           )

samples.each do |str|
  puts str
  puts " => #{remove_comment(str)}"
end

