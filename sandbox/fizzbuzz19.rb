# -*- encoding: utf-8 -*-

fizzbuzz = Fiber.new do
  fizz = ["", "", "Fizz"].cycle
  buzz = ["", "", "", "", "Buzz"].cycle
  n = 1
  while
    s = fizz.next + buzz.next
    Fiber.yield(s == "" ? n.to_s : s)
    n += 1
  end
end


100.times{ puts fizzbuzz.resume }


