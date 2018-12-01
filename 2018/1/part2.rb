#!/usr/bin/env ruby
require "set"

inputs = ARGF.each_line.map { |l| l.chomp.to_i }

seen = Set.new
current = 0
inputs.cycle.each do |change|
  current += change
  if !seen.add?(current)
    puts current
    break
  end
end
