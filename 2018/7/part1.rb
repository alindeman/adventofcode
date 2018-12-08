#!/usr/bin/env ruby
require "set"

class InstructionSet
  def initialize
    @steps = Hash.new { |h, k| h[k] = Set.new }
  end

  def add_rule(step, dependency)
    @steps[step] << dependency
  end

  def to_s
    ready = SortedSet.new(
      @steps.
        values.
        reduce(&:union).
        select { |k| @steps[k].empty? }
    )

    completed = []
    worked = Set.new
    until ready.empty?
      step = ready.first
      ready.delete(step)

      worked.add(step)
      completed << step

      @steps.
        select { |k, v| !worked.include?(k) && worked.superset?(v) }.
        each { |k, v| ready.add(k) }
    end
    completed.join
  end
end

set = InstructionSet.new
ARGF.each_line do |line|
  if /\AStep (?<dependency>\S+) must be finished before step (?<step>\S+) can begin.\Z/ =~ line
    set.add_rule(step, dependency)
  else
    abort "invalid line: #{line}"
  end
end
puts set.to_s
