class Claim
  def self.parse(line)
    if %r{#(?<id>\d+) @ (?<x>\d+),(?<y>\d+): (?<w>\d+)x(?<h>\d+)} =~ line
      return Claim.new(id.to_i, x.to_i, y.to_i, w.to_i, h.to_i)
    else
      raise ArgumentError, "invalid line: #{line}"
    end
  end

  attr_reader :id, :x, :y, :w, :h
  def initialize(id, x, y, w, h)
    @id = id
    @x = x
    @y = y
    @w = w
    @h = h
  end

  def each_cell
    return enum_for(:each_cell) unless block_given?

    x.upto(x + w - 1) do |xp|
      y.upto(y + h - 1) do |yp|
        yield [xp, yp]
      end
    end
  end
end

class Fabric
  def initialize
    @cells = []
    @claims = []
  end

  def make_claim(claim)
    claim.each_cell do |x, y|
      @cells[x] ||= []
      @cells[x][y] = (@cells[x][y] || []).push(claim)
    end

    @claims << claim
  end

  def num_overlapping_claims
    @cells.compact.map { |row|
      row.compact.count { |cells| cells.length >= 2 }
    }.sum
  end

  def non_overlapping_claims
    @claims.select { |claim|
      claim.each_cell.all? { |x, y|
        @cells[x][y].length == 1
      }
    }
  end
end

