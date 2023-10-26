class ChordsForKeyHandler
  def initialize(key, is_seventh: false)
    @key = Note.new(key)
    @is_seventh = is_seventh
  end

  def chords
    modes.each_with_object({}) do |mode, suggestions|
      suggestions[mode.name] = Scale.new(@key, mode).chords
    end
  end

  private

  def modes
    @modes ||= [
      Ionian.new(is_seventh: @is_seventh),
      Dorian.new(is_seventh: @is_seventh),
      Phrygian.new(is_seventh: @is_seventh),
      Lydian.new(is_seventh: @is_seventh),
      Mixolydian.new(is_seventh: @is_seventh),
      Aeolian.new(is_seventh: @is_seventh),
      Locrian.new(is_seventh: @is_seventh)
    ]
  end
end
