#!/usr/bin/env ruby
require_relative "guard_event"

# id => [start1...end1, start2...end2, ...]
sleeps_by_id = ARGF.each_line.
  map { |l| GuardEvent.parse(l) }.
  sort_by { |e| e.time }.
  slice_before { |e| e.type == GuardEvent::BEGINS_SHIFT }.
  each_with_object(Hash.new { |h, k| h[k] = [] }) { |events, h|
    h[events[0].id].concat(
      events[1..-1].
        each_slice(2).
        map { |events| (events[0].time...events[1].time) }
    )
  }

# minute => {id => occurrences}
minutes_asleep_by_minute_and_id = sleeps_by_id.
  each_with_object(Hash.new { |h, k| h[k] = Hash.new(0) }) { |(id, sleeps), h|
    sleeps.each do |sleep|
      sleep.begin.min.upto(sleep.end.min - 1) do |min|
        h[min][id] += 1
      end
    end
  }

most_asleep_minute = minutes_asleep_by_minute_and_id.
  max_by { |minute, by_id| by_id.max_by { |_, occurrences| occurrences }.last }.
  first

most_asleep_guard_on_most_asleep_minute = minutes_asleep_by_minute_and_id.
  fetch(most_asleep_minute).
  max_by { |_, occurrences| occurrences }.
  first

p most_asleep_minute * most_asleep_guard_on_most_asleep_minute
