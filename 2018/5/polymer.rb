class Polymer
  def initialize(str)
    @str = str.dup
  end

  def remove!(char)
    @str.tr!([char, char.swapcase].join, "")
    self
  end

  def fully_react!
    i = 0
    while i < @str.length - 1
      i = 0 if i < 0
      if destroys?(@str[i], @str[i + 1])
        @str.slice!(i..i+1)
        i -= 1
      else
        i += 1
      end
    end

    self
  end

  def to_s
    @str
  end

  private

  def destroys?(a, b)
    a != b && a.upcase == b.upcase
  end
end
