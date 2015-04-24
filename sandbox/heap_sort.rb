class Node

  attr_accessor :val, :left, :right
  attr_reader   :parent

  def initialize(val, parent = nil)
    @val = val
    @parent = parent
    @left = nil
    @right = nil
  end

end   # of class Node


class HeapTree

  def initialize
    @root = nil
  end

  def insert(val)
    if @root.nil?
      @root = Node.new(val)
    else
      v = vacant
      n = Node.new(val, v)
      if v.left.nil?
        v.left = n
      else
        v.right = n
      end
      upheap(n)
    end
  end

  def shift
    if @root.nil?
      nil
    else
      val = @root.val
      @root.val = delete_last
      downheap(@root)
      val
    end
  end

  def upheap(node)
    until node.parent.nil? || node.val > node.parent.val
      v = node.val
      node.val = node.parent.val
      node.parent.val = v
      node = node.parent
    end
  end

  def downheap(node)
    return nil if node.nil?
    until node.left.nil?
      if node.right.nil? || node.left.val < node.right.val
        if node.val > node.left.val
          v = node.val
          node.val = node.left.val
          node.left.val = v
          node = node.left
        else
          break
        end
      else
        if node.val > node.right.val
          v = node.val
          node.val = node.right.val
          node.right.val = v
          node = node.right
        else
          break
        end
      end
    end
  end


  def vacant
    q = [@root]
    while n = q.shift
      if n.left.nil? || n.right.nil?
        return n
      else
        q << n.left
        q << n.right
      end
    end
  end

  def last
    q = [@root]
    begin
      n = q.shift
      q << n.left if n.left
      q << n.right if n.right
    end until q.empty?
    n
  end

  def delete_last
    node = last
    if node.parent.nil?
      @root = nil
    else
      if node.parent.right == node
        node.parent.right = nil
      else
        node.parent.left = nil
      end
    end
    node.val
  end

  def print_tree
    s = [[@root, 0]]
    while n = s.pop
      if n[0].nil?
        puts ""
      else
        puts " " * n[1] + n[0].val.to_s
        s.push([n[0].right, n[1]+2]) if n[0].right
        s.push([n[0].left, n[1]+2]) if n[0].left
      end
    end
  end

end   # of HeapTree



if $0 == __FILE__
  ary = (1..100).to_a.sample(10)
  puts "unsorted: " + ary.inspect
  heap = HeapTree.new
  ary.each do |x|
    heap.insert(x)
  end
  sorted = []
  while v = heap.shift do
    sorted << v
  end
  puts "sorted:   " + sorted.inspect
end
