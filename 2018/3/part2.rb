#!/usr/bin/env ruby
require_relative "fabric"

f = Fabric.new
ARGF.each_line do |line|
  f.make_claim(Claim.parse(line))
end
puts f.non_overlapping_claims.map(&:id).join(" ")
