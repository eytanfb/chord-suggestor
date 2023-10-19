class ChordPlayerService
  def initialize(chord)
    @chord = chord
  end

  def play
    samples = chord.notes.map(&:sample_for_note)
    "playChord(#{samples.to_json});"
  end
end
