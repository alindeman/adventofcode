#!/usr/bin/env ruby
require_relative "polymer"

polymer = Polymer.new(ARGF.read.chomp).fully_react!
puts polymer.to_s.length
