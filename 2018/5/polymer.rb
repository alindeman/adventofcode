class Polymer
  class Node
    attr_reader :char
    attr_accessor :next_node

    def initialize(char, next_node)
      @char = char
      @next_node = next_node
    end

    def destroys?(other_node)
      char != other_node.char && char.upcase == other_node.char.upcase
    end
  end

  def initialize(str)
    @head = str.reverse.each_char.inject(nil) do |next_node, char|
      Node.new(char, next_node)
    end
  end

  def fully_react!
    loop while react!
    self
  end

  def react!
    changed = false

    n1, n2, n3 = nil, @head, @head.next_node
    until n3.nil?
      if n2.destroys?(n3)
        if n1.nil?
          @head = n3.next_node
        else
          n1.next_node = n3.next_node
        end

        changed = true
      end

      n1, n2, n3 = n2, n3, n3.next_node
    end

    changed
  end

  def to_s
    str = ""
    node = @head
    until node.nil?
      str << node.char
      node = node.next_node
    end
    str
  end
end
