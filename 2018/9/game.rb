class Marble
  attr_reader :value
  attr_accessor :prev, :next

  def initialize(value)
    @value = value
  end

  def to_s
    value
  end
end

class Game
  attr_reader :scores

  def initialize
    @scores = Hash.new(0)

    @current = @zero = Marble.new(0)
    @current.prev = @current.next = @current
  end

  def play(player_id, marble_value)
    if marble_value % 23 == 0
      removed_marble = 7.times.inject(@current) { |marble| marble.prev }
      @scores[player_id] += (marble_value + removed_marble.value)

      removed_marble.prev.next = removed_marble.next
      removed_marble.next.prev = removed_marble.prev
      @current = removed_marble.next
    else
      marble = Marble.new(marble_value)

      # marble will be inserted between n and n_next
      n = @current.next
      n_next = n.next

      n.next = marble
      marble.prev = n

      n_next.prev = marble
      marble.next = n_next

      @current = marble
    end
  end

  def to_s
    str = ""

    m = @zero
    loop do
      if m == @current
        str << "(#{m.to_s}) "
      else
        str << "#{m.to_s} "
      end

      m = m.next
      break if m == @zero
    end

    str
  end
end

