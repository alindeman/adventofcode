#!/usr/bin/env ruby
require_relative "instruction_set"

set = InstructionSet.new
ARGF.each_line do |line|
  if /\AStep (?<dependency>\S+) must be finished before step (?<step>\S+) can begin.\Z/ =~ line
    set.add_rule(step, dependency)
  else
    abort "invalid line: #{line}"
  end
end
puts set.total_time
