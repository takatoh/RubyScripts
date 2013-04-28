# coding: utf-8
#
# Check digits with Luhn algorithm


def check_number(digits)
  even = false
  sum = digits.reverse.split(//).inject(0) do |s, d|
    d = d.to_i
    if even
      d = d * 2
      s -= 9 if d > 9
    end
    even = !even
    s += d
  end
  sum % 10 == 0
end


NUMBERS = [ '5555555555554444',
            '5105105105105100',
            '4111111111111111',
            '4012888888881881',
            '3530111333300000',
            '3566002020360505',
            '30569309025904',
            '38520000023237',
            '378282246310005',
            '371449635398431',
            '378734493671000',
            '6011111111111117',
            '6011000990139424'
           ]


NUMBERS.each do |digits|
  puts check_number(digits)
end

