#!/usr/bin/env ruby
require "set"

class Point
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def manhattan_distance_from(other)
    (other.x - x).abs + (other.y - y).abs
  end

  def ==(other)
    x == other.x && y == other.y
  end
  alias_method :eql?, :==

  def hash
    x.hash ^ y.hash
  end
end

class Grid
  def initialize(points)
    @points = points
  end

  def bounds
    @bounds ||= [
      Point.new(@points.map(&:x).min, @points.map(&:y).min),
      Point.new(@points.map(&:x).max, @points.map(&:y).max),
    ]
  end

  def points_surrounding_bounds
    return @points_surrounding_bounds if defined?(@points_surrounding_bounds)

    @points_surrounding_bounds = []

    # top
    @points_surrounding_bounds.concat(
      (bounds[0].x - 1).upto(bounds[1].x + 1).map { |x| Point.new(x, bounds[0].y) }
    )

    # bottom
    @points_surrounding_bounds.concat(
      (bounds[0].x - 1).upto(bounds[1].x + 1).map { |x| Point.new(x, bounds[1].y) }
    )

    # left
    @points_surrounding_bounds.concat(
      (bounds[0].y - 1).upto(bounds[1].y + 1).map { |y| Point.new(bounds[0].x, y) }
    )

    # right
    @points_surrounding_bounds.concat(
      (bounds[0].y - 1).upto(bounds[1].y + 1).map { |y| Point.new(bounds[1].x, y) }
    )

    @points_surrounding_bounds
  end

  def points_with_infinite_areas
    # A point will have infinite area if it's closest to any of the points
    # surrounding the bounds
    @points_with_infinite_areas ||= Set.new(points_surrounding_bounds.map { |p| point_closest_to(p) })
  end

  def point_closest_to(point)
    candidates = @points.
      map { |p| [p, p.manhattan_distance_from(point)] }.
      sort_by { |p, distance| distance }

    if candidates.length == 0
      nil
    elsif candidates.length == 1
      candidates[0].first
    elsif candidates[0].last != candidates[1].last
      candidates[0].first
    else
      nil # tie
    end
  end

  def areas_by_point
    bounds[0].x.upto(bounds[1].x).each_with_object(Hash.new(0)) do |x, h|
      bounds[0].y.upto(bounds[1].y) do |y|
        p = point_closest_to(Point.new(x, y))
        h[p] += 1 if p
      end
    end
  end

  def areas_by_point_excluding_infinite
    Hash[areas_by_point.reject { |p, distance| points_with_infinite_areas.include?(p) }]
  end
end

points = ARGF.each_line.map { |line|
  if /\A(?<x>\d+), (?<y>\d+)\Z/ =~ line
    Point.new(x.to_i, y.to_i)
  else
    abort "invalid line: #{line}"
  end
}
grid = Grid.new(points)
puts grid.areas_by_point_excluding_infinite.
  max_by { |p, distance| distance }.
  last
