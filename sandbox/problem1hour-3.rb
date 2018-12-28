require 'pp'

def fib(a, b, acc, n)
  if n == 0
    acc
  else
    acc << a
    fib(b, a + b, acc, n - 1)
  end
end

def solv
  fib(0, 1, [], 100)
end

pp solv
