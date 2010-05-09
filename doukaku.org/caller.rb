#
# cf. http://ja.doukaku.org/28/
#

def foo
  /.*`(.+)'/ =~ caller(1)[0]
  $1
end

def bar; foo; end
def baz; foo; end

p bar                     # => "bar"
p baz                     # => "baz"

