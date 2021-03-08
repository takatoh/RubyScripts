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
    sprintf("%.#{d}f#{units[u]}", bytes)
  end
  module_function :human_bytes
end

