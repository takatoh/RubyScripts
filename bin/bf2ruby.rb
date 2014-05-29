# encoding: utf-8
#
# Translate source code from BrainFu*k into Ruby.
#

print <<"EOBF"
class BF
  def initialize
    @memory = [0]
    @pointer = 0
  end
  def current
    @memory[@pointer]
  end
  def incr
    @memory[@pointer] += 1
  end
  def decr
    @memory[@pointer] -= 1
  end
  def rshift
    @pointer += 1
    unless @memory[@pointer]
      @memory << 0
    end
  end
  def lshift
    @pointer -= 1
  end
  def getc
    @memory[@pointer] = STDIN.getc.ord
  end
  def printc
    print @memory[@pointer].chr
  end
end

bf = BF.new

EOBF

commands = {
  ">" => "bf.rshift",
  "<" => "bf.lshift",
  "+" => "bf.incr",
  "-" => "bf.decr",
  "." => "bf.printc",
  "," => "bf.getc",
  "[" => "begin; break if bf.current.zero?",
  "]" => "end until bf.current.zero?"
}

ARGF.each_byte do |c|
  cmd = commands[c.chr]
  puts cmd if cmd
end
