class BinaryTree

  def initialize(x)
    @val = x
    @left = nil
    @right = nil
  end

  def insert(x)
    if x < @val
      @left.nil? ? @left = BinaryTree.new(x) : @left.insert(x)
    else
      @right.nil? ? @right = BinaryTree.new(x) : @right.insert(x)
    end
  end

  def traverse(&block)
    @left.traverse(&block) unless @left.nil?
    block.call(@val)
    @right.traverse(&block) unless @right.nil?
  end

end


def sort(ary)
  btree = BinaryTree.new(ary.shift)
  ary.each{|x| btree.insert(x) }
  [].tap{|a| btree.traverse{|v| a << v } }
end



if $0 == __FILE__
  sample = (1..100).to_a.sample(10)
  puts "unsorted: " + sample.inspect
  result = sort(sample)
  puts "sorted:   " + result.inspect
end
