class Chord
  attr_reader :notes

  def initialize(root, chord_shape)
    @root = root
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

  def display_joined_notes
    @notes.map(&:name).join(' - ')
  end

  def note_samples
    @notes.map(&:sample_for_note)
  end
end
