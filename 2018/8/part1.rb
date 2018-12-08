#!/usr/bin/env ruby
require_relative "license_tree"

entries = ARGF.read.chomp.split(/\s+/).map(&:to_i)
license_tree = LicenseTree.parse(entries)
puts license_tree.flat_map(&:metadata).sum
