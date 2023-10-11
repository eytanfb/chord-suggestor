class Chord
  attr_reader :notes

  def initialize(root, key, chord_shape)
    @root = root
    @key = key
    @chord_shape = chord_shape
    @notes = []

    @chord_shape.intervals.each do |interval|
      @notes << @root.up(interval)
    end
  end

  def name
    @root.name + @chord_shape.quality_representation
  end

  def quality
    @chord_shape.quality
  end

  def ==(other)
    @notes == other.notes
  end
end
