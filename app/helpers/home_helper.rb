module HomeHelper
  ROMAN = {
    UPPERCASE: {
      1 => 'I',
      2 => 'II',
      3 => 'III',
      4 => 'IV',
      5 => 'V',
      6 => 'VI',
      7 => 'VII'
    },
    LOWERCASE: {
      1 => 'i',
      2 => 'ii',
      3 => 'iii',
      4 => 'iv',
      5 => 'v',
      6 => 'vi',
      7 => 'vii'
    }
  }.freeze

  CHORD_MODIFIERS = {
    'Flat' => 'b',
    'Sharp' => '#',
    'Diminished' => '°',
    'Augmented' => '+',
    'Major' => 'M',
    'Minor' => 'm'
  }.freeze

  # create regex for roman numerals
  # roman numeral should not be surrounded by another letter
  ROMAN_REGEX = /(?<!\w)([ivIV]{1,3})(?!\w)/

  def chord_representation(chord, index)
    final_chord = chord
    index_to_chord_number = index + 1

    chord_modifiers.each do |modifier|
      final_chord = modifier.execute(final_chord, index_to_chord_number) if modifier.exists_in?(chord)
    end

    final_chord
  end

  private

  def chord_modifiers
    @chord_modifiers ||= [
      CodeModifier.new('Major', 'M', [:upcase_roman]),
      CodeModifier.new('Minor', 'm', [:downcase_roman]),
      CodeModifier.new('Diminished', '°', %i[downcase_roman suffix]),
      CodeModifier.new('Augmented', '+', %i[downcase_roman suffix]),
      CodeModifier.new('Flat', 'b', [:prefix]),
      CodeModifier.new('Sharp', '#', [:prefix])
    ]
  end

  class CodeModifier
    def initialize(name, symbol, behaviors)
      @name = name
      @symbol = symbol
      @behaviors = behaviors
    end

    def exists_in?(chord)
      chord.include?(@name)
    end

    def execute(chord, chord_number)
      @behaviors.each do |behavior|
        chord = send(behavior, chord, chord_number)
      end

      chord
    end

    private

    def to_roman(number, is_minor: true)
      is_minor ? ROMAN[:LOWERCASE][number] : ROMAN[:UPPERCASE][number]
    end

    def prefix(chord, _chord_number)
      chord.gsub(@name, @symbol)
    end

    def suffix(chord, _chord_number)
      return chord.gsub(@name, @symbol) if chord.include?(@name)

      chord + @symbol
    end

    def upcase_roman(chord, chord_number)
      return chord if chord.match?(ROMAN_REGEX)

      chord.gsub(@name, to_roman(chord_number, is_minor: false))
    end

    def downcase_roman(chord, chord_number)
      return chord if chord.match?(ROMAN_REGEX)

      chord.gsub(@name, to_roman(chord_number))
    end
  end
end
