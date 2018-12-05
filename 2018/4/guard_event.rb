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
