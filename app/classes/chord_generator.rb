class ChordGenerator
  def self.from_string(chord_string)
    chord_shape = shape_from_string(chord_string)
    note        = note_from_string(chord_string)

    Chord.new(note, chord_shape)
  end

  def self.shape_from_string(chord_string)
    original_string = chord_string.dup
    Note::SEMITONES.each_key do |note|
      original_string.gsub!(note, '')
    end

    inverse_quality_representation = ChordShape::QUALITY_REPRESENTATIONS_INVERSE
    ChordShape.new(inverse_quality_representation[original_string])
  end

  def self.note_from_string(chord_string)
    result = Note::SEMITONES.keys.find do |note|
      chord_string.include?(note)
    end

    Note.new(result)
  end
end
