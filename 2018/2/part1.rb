#!/usr/bin/env ruby

exactly_twice = 0
exactly_three_times = 0
ARGF.each_line do |line|
  line = line.chomp

  counts = line.each_char
    .each_with_object(Hash.new(0)) { |c, h| h[c] += 1 }

  if counts.any? { |_, count| count == 2 }
    exactly_twice += 1
  end
  if counts.any? { |_, count| count == 3 }
    exactly_three_times += 1
  end
end

puts exactly_twice * exactly_three_times
