class ChordGroup
  attr_reader :primary_chord, :alternative_chords

  def initialize(chord)
    @primary_chord = chord
    @alternative_chords = []
  end

  def add_alternative(chord)
    @alternative_chords << chord
  end

  def ==(other)
    primary_chord == other.primary_chord &&
      alternative_chords == other.alternative_chords
  end
end
