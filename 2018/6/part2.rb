#!/usr/bin/env ruby
require_relative "grid"

points = ARGF.each_line.map { |line|
  if /\A(?<x>\d+), (?<y>\d+)\Z/ =~ line
    Point.new(x.to_i, y.to_i)
  else
    abort "invalid line: #{line}"
  end
}
grid = Grid.new(points)
puts grid.area_containing_safe_distances
