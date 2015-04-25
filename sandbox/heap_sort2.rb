class Heap

  def initialize
    @heap = []
  end

  def insert(x)
    @heap << x
    upheap
    self
  end

  def shift
    v = @heap.shift
    @heap.unshift(@heap.pop)
    downheap
    v
  end

  def upheap
    k = @heap.size - 1
    j = (k - 1) / 2                           # parent of k
    until k == 0 || @heap[j] < @heap[k]
      @heap[j], @heap[k] = @heap[k], @heap[j]
      k = j
      j = (k - 1) / 2
    end
  end

  def downheap
    k = 0
    i = 2 * k + 1                             # left child of k
    j = 2 * k + 2                             # right child of k
    until @heap[i].nil?                       # no children
      if @heap[j].nil? || @heap[i] < @heap[j]
        if @heap[k] < @heap[i]
          break
        else
          @heap[i], @heap[k] = @heap[k], @heap[i]
          k = i
          i = 2 * k + 1
          j = 2 * k + 2
        end
      else
        if @heap[k] < @heap[j]
          break
        else
          @heap[j], @heap[k] = @heap[k], @heap[j]
          k = j
          i = 2 * k + 1
          j = 2 * k + 2
        end
      end
    end
  end

end  # of class Heap


def heap_sort(ary)
  heap = Heap.new
  ary.each{|x| heap.insert(x) }
  result = []
  while y = heap.shift
    result << y
  end
  result
end



if $0 == __FILE__
  ary = (1..100).to_a.sample(10)
  puts "unsorted: " + ary.inspect
  result = heap_sort(ary)
  puts "sorted:   " + result.inspect
end
