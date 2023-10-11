class ChordSuggestionHandler
  def initialize(key)
    @key = Note.new(key)
  end

  def suggest_chords
    modes.each_with_object({}) do |mode, suggestions|
      suggestions[mode.name] = Scale.new(@key, mode).chords
    end
  end

  private

  def modes
    @modes ||= [
      Ionian.new,
      Dorian.new,
      Phrygian.new,
      Lydian.new,
      Mixolydian.new,
      Aeolian.new,
      Locrian.new
    ]
  end
end
