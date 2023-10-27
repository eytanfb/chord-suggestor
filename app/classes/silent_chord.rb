class SilentChord < Chord
  attr_reader :notes, :name

  def initialize
    @root = 'Silence'
    @chord_shape = SilentChordShape.new
    @notes = []
    @name = 'Silence'
  end

  def quality
    @chord_shape
  end

  def ==(other)
    @root == other.name
  end

  def display_joined_notes
    ''
  end

  def note_samples
    []
  end

  def minor?
    false
  end
end
