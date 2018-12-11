#!/usr/bin/env ruby
require "set"

class Point
  attr :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def ==(other)
    x == other.x && y == other.y
  end
  alias_method :eql?, :==

  def hash
    x.hash ^ y.hash
  end

  def to_s
    "(#{x}, #{y})"
  end
end

class MovingPoint < Point
  def self.parse(line)
    if /\Aposition=<\s*(?<x>-?\d+),\s*(?<y>-?\d+)> velocity=<\s*(?<dx>-?\d+),\s*(?<dy>-?\d+)>\Z/ =~ line
      new(x.to_i, y.to_i, dx.to_i, dy.to_i)
    else
      raise ArgumentError, "invalid line: #{line}"
    end
  end

  def initialize(x, y, dx, dy)
    super(x, y)

    @dx = dx
    @dy = dy
  end

  def move!
    @x += @dx
    @y += @dy
  end
end

class Sky
  def initialize(points)
    @points = points
  end

  def step!
    @points.each(&:move!)
  end

  def bounds
    xs = @points.map(&:x)
    ys = @points.map(&:y)

    xmin, xmax = xs.minmax
    ymin, ymax = ys.minmax

    [Point.new(xmin, ymin), Point.new(xmax, ymax)]
  end

  def to_s
    str = ""

    pset = Set.new(@points)
    pmin, pmax = bounds
    pmin.y.upto(pmax.y) do |y|
      pmin.x.upto(pmax.x) do |x|
        if pset.include?(Point.new(x, y))
          str << "X"
        else
          str << " "
        end
      end

      str << "\n"
    end

    str
  end
end

i = 0
possibly_found = false
countdown = 30

points = ARGF.each_line.map { |line| MovingPoint.parse(line) }
sky = Sky.new(points)
while countdown > 0
  countdown -= 1 if possibly_found

  bounds = sky.bounds
  if (bounds[1].y - bounds[0].y).abs < 100 && (bounds[1].x - bounds[0].x).abs < 100
    possibly_found = true
    puts "(#{i})"
    puts sky.to_s
    puts " ------------------------------------ "
  end

  sky.step!
  i += 1
end
