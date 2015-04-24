module Node

  class Node

    attr_accessor :data, :left, :right

    def initialize(x)
      @data = x
      @left = nil
      @right = nil
    end

  end


  def self.search(node, x)
    while node
      return true if node.data == x
      if x < node.data
        node = node.left
      else
        node = node.right
      end
    end
    return false
  end

  def self.insert(node, x)
    if node.nil?
      return Node.new(x)
    elsif x == node.data
      return node
    elsif x < node.data
      node.left = insert(node.left, x)
    else
      node.right = insert(node.right, x)
    end
    return node
  end

  def self.search_min(node)
    if node.left.nil?
      return node.data
    else
      return search_min(node.left)
    end
  end

  def self.delete_min(node)
    return node.right if node.left.nil?
    node.left = delete_min(node.left)
    return node
  end

  def self.delete(node, x)
    if node
      if x == node.data
        if node.left.nil?
          return node.right
        elsif node.right.nil?
          return node.left
        else
          node.data = search_min(node.right)
          node.right = delete_min(node.right)
        end
      elsif x < node.data
        node.left = delete(node.left, x)
      else
        node.right = delete(node.right, x)
      end
    end
    return node
  end

  def self.traverse_h(func, node)
    if node
      traverse_h(func, node.left)
      func.call(node.data)
      traverse_h(func, node.right)
    end
  end

end  # end of module Node


class BinaryTree

  def initialize
    @root = nil
  end

  def search(x)
    return Node.search(@root, x)
  end

  def insert(x)
    @root = Node.insert(@root, x)
  end

  def delete(x)
    @root = Node.delete(@root, x)
  end

  def traverse_h(func)
    Node.traverse_h(func, @root)
  end

  def to_s
    @data = []
    traverse_h(lambda{|x| @data << x })
    return "<BinaryTree: #{@data.inspect} >"
  end

end   # of class BinaryTree



if $0 == __FILE__
  tree = BinaryTree.new
  data = (1..100).to_a.sample(10)
  p data
  puts tree
  data.each{|x| tree.insert(x) }
  puts tree
  data.each do |x|
    puts "search #{x} #{tree.search(x)}"
    puts "delete #{x}"
    tree.delete(x)
    puts "search #{x} #{tree.search(x)}"
    puts tree
  end
end
