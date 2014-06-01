#! ruby
# -*- encoding: utf-8 -*-
#
#  miilaw.rb - Methinks It Is Like A Weasel.
#

require 'optparse'


IDEAL = "METHINKS IT IS LIKE A WEASEL"


class Individual
  def initialize(phenotype)
    @phenotype = phenotype.upcase
  end

  attr_reader :phenotype

  def delivery
    next_phenotype = @phenotype.dup
    next_phenotype[rand(@phenotype.size)] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ ".slice(rand(27), 1)
    Individual.new(next_phenotype)
  end

  def breed(n)
    next_generation = []
    n.times do
      next_generation << delivery
    end
    next_generation
  end

  def to_s
    @phenotype
  end
end

class Nature
  def initialize(ideal)
    @ideal = ideal
  end

  def select(group)
    r = []
    max = 0
    group.each do |i|
      s = evaluate(i)
      if s > max
        max = s
        r = [i]
      elsif s == max
        r << i
      end
    end
    r[0]
  end

  def evaluate(ind)
    phenotype = ind.phenotype
    score = 0
    0.upto(@ideal.size - 1) do |i|
      score += 1 if phenotype[i] == @ideal[i]
    end
    score
  end
end


def err_exit(msg)
  $stderr.print msg
  exit
end


options = {:number => 100}
opts = OptionParser.new
opts.banner = "Usage: ruby miilaw.rb [option] initial\n"
opts.on_tail('-h', '--help', 'show this massage.') {puts opts; exit(0)}
opts.on('-n', '--number=NUM', Integer, 'set number of children.') {|v| options[:number] = v}
opts.parse!

err_exit(opts.help) if ARGV.empty?

len = IDEAL.size
init = ARGV.shift.upcase
if init.size < len
  init = "%-#{len}s" % init
elsif init.size > len
  init = init[0,len]
end

individual = Individual.new(init)
nature = Nature.new(IDEAL)

genaration = 0
print "#{genaration} : #{individual}\n"
while true do
  genaration += 1
  next_gen = individual.breed(options[:number])
  individual = nature.select(next_gen)
  print "#{genaration} : #{individual}\n"
  break if individual.phenotype == IDEAL
end
