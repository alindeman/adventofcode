class LicenseTree
  include Enumerable

  attr_reader :children, :metadata

  def self.parse(entries)
    node, _ = _parse(entries)
    node
  end

  def self._parse(entries, offset = 0)
    num_children = entries[offset]
    offset += 1

    num_metadata = entries[offset]
    offset += 1

    children = num_children.times.map {
      child, offset = _parse(entries, offset)
      child
    }

    metadata = num_metadata.times.map {
      metadata = entries[offset]
      offset += 1
      metadata
    }

    [new(children, metadata), offset]
  end

  def initialize(children, metadata)
    @children = children
    @metadata = metadata
  end

  def each(&blk)
    return enum_for(:each) if blk.nil?

    blk.call(self)
    children.each { |c| c.each(&blk) }
  end

  def value
    if children.empty?
      metadata.sum
    else
      metadata.map { |i| children[i - 1]&.value }.compact.sum
    end
  end
end

