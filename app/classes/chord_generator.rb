class ChordGenerator
  def self.from_string(chord_string)
    Chord.new(note_from_string(chord_string), shape_from_string(chord_string))
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
    note_name = Note::SEMITONES.keys.find { |note| chord_string.include?(note) }
    Note.new(note_name)
  end
end
