#!/usr/bin/env ruby
require "set"

ids = ARGF.each_line.map(&:chomp)
ids.product(ids) do |i1, i2|
  next if i1 == i2

  same_chars = ""
  i1.each_char.zip(i2.each_char) do |c1, c2|
    same_chars += c1 if c1 == c2
  end

  if same_chars.length == (i1.length - 1)
    puts same_chars
    break
  end
end
