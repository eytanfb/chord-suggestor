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
    @primary_chord == other.primary_chord && @alternative_chords == other.alternative_chords
  end

  def self.from_json(json)
    primary_chord = Chord.from_json(json['primary_chord'])
    chord_group = ChordGroup.new(primary_chord)

    json['alternative_chords'].each do |alternative_chord_json|
      chord_group.add_alternative(Chord.from_json(alternative_chord_json))
    end

    chord_group
  end
end
