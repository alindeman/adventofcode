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

sleepiest_guard_id = sleeps_by_id.
  each_with_object(Hash.new(0)) { |(id, sleeps), h| h[id] += sleeps.sum { |r| r.end.min - r.begin.min } }.
  max_by { |id, minutes_asleep| minutes_asleep }.
  first

minute_most_asleep = sleeps_by_id.
  fetch(sleepiest_guard_id).
  flat_map { |sleep| (sleep.begin.min...sleep.end.min).to_a }.
  each_with_object(Hash.new(0)) { |m, h| h[m] += 1 }.
  max_by { |_minute, times_asleep_during_minute | times_asleep_during_minute }.
  first

puts sleepiest_guard_id * minute_most_asleep
