#! ruby
# -*- encoding: utf-8 -*-


class HQ9Plus
  def initialize
    @counter = 0
  end

  def run(source)
    @src = source
    @src.each_char do |c|
      case c
      when "H"
        hello
      when "Q"
        quine
      when "9"
        print_99_bottles_of_beer
      when "+"
        incliment
      end
    end
  end

  private

  def hello
    puts "Hello, world."
  end

  def quine
    print @src
  end

  def print_99_bottles_of_beer
    99.downto(0) do |k|
      case k
      when 0
        before = "no more bottles"
        after = "99 bottles"
      when 1
        before = "1 bottle"
        after = "no more bottles"
      when 2
        before = "2 bottles"
        after = "1 bottle"
      else
        before = "#{k} bottles"
        after = "#{k-1} bottles"
      end

      if k == 0
        action = "Go to the store and buy some more"
      else
        action = "Take on down and pass it around"
      end

      puts "#{before.capitalize} of beer on the wall, #{before} of beer."
      puts "#{action}, #{after} of beer on the wall."
      puts "" unless k == 0
    end
  end

  def increment
    @counter += 1
  end
end


hq9plus = HQ9Plus.new
hq9plus.run(File.read(ARGV.shift))

