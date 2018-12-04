#!/usr/bin/env ruby

class Fabric
  def initialize
    @squares = []
  end

  def claim(x, y, w, h)
    x.upto(x + w - 1) do |xp|
      @squares[xp] ||= []
      y.upto(y + h - 1) do |yp|
        @squares[xp][yp] = (@squares[xp][yp] || 0) + 1
      end
    end
  end

  def num_overlapping_claims
    @squares.compact.map { |row|
      row.compact.count { |cell| cell >= 2 }
    }.sum
  end
end

f = Fabric.new
ARGF.each_line do |line|
  abort "invalid line: #{line}" unless %r{#(?<id>\d+) @ (?<x>\d+),(?<y>\d+): (?<w>\d+)x(?<h>\d+)} =~ line

  f.claim(x.to_i, y.to_i, w.to_i, h.to_i)
end

p f.num_overlapping_claims
