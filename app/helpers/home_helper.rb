module HomeHelper
  def note_asset_name(note)
    "#{note.gsub('#', '_sharp').gsub('b', '_flat')}.wav"
  end

  ROMAN_NUMERALS = %w[I II III IV V VI VII].freeze

  def degree_label(index, quality)
    numeral = ROMAN_NUMERALS[index]
    if %w[Minor Minor\ 7 Half\ Diminished\ 7 Minor\ 7\ Flat\ 5 Minor\ 6].include?(quality)
      numeral.downcase
    elsif %w[Diminished Diminished\ 7].include?(quality)
      "#{numeral.downcase}\u00B0"
    elsif %w[Augmented Augmented\ 7].include?(quality)
      "#{numeral}+"
    else
      numeral
    end
  end
end
