# encoding: utf-8
#
# HumanBytes module
#

module HumanBytes
  def human_bytes(bytes)
    units = %w( B KB MB GB TB PB EB ZB YB )
    u = 0
    until bytes < 1000.0
      bytes = bytes / 1000.0
      u += 1
    end
    d = bytes >= 100 ? 0 : (bytes >= 10 ? 1 : 2)
#    roundoff(bytes, d).to_s + units[u]
    sprintf("%.#{d}f#{units[u]}", bytes)
  end
  module_function :human_bytes

  private

  def self.roundoff(n, d = 0)
    x = 10**d
    r = (n * x + 0.5).floor
    d.zero? ? r : r.quo(x).to_f
  end
end

