#!/usr/bin/env ruby

class GuardEvent
  def self.parse(str)
    if %r{^\[(?<year>\d{4})-(?<month>\d{2})-(?<day>\d{2}) (?<hour>\d{2}):(?<minute>\d{2})\] (?<msg>.*)$} =~ str
      time = Time.utc(year.to_i, month.to_i, day.to_i, hour.to_i, minute.to_i)

      case str
      when /falls asleep/
        GuardEvent.new(time, nil, FALLS_ASLEEP)
      when /wakes up/
        GuardEvent.new(time, nil, WAKES_UP)
      when /Guard #(\d+) begins shift/
        GuardEvent.new(time, $1.to_i, BEGINS_SHIFT)
      else
        raise ArgumentError, "unknown message: #{msg}"
      end
    else
      raise ArgumentError, "unparsable event: #{str}"
    end
  end

  BEGINS_SHIFT = :begins_shift
  WAKES_UP = :wakes_up
  FALLS_ASLEEP = :falls_asleep

  attr_accessor :time, :id, :type

  def initialize(time, id, type)
    @time = time
    @id = id
    @type = type
  end
end

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
