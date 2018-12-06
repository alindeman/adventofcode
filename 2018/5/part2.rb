#!/usr/bin/env ruby
require_relative "polymer"

str = ARGF.read.chomp
puts ('a'..'z').map { |c|
  polymer = Polymer.new(str).remove!(c).fully_react!
  polymer.to_s.length
}.min
