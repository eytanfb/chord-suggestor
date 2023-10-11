class ChordSuggestor
  SHARP_KEYS = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B']
  FLAT_KEYS = %w[C Db D Eb E F Gb G Ab A Bb Cb]

  CHORDS_WITH_SHARPS = %w[C G D A E B]
  CHORDS_WITH_FLATS = %w[F Bb Eb Ab Db Gb]

  MODES = [
    IonianMode.new,
    DorianMode.new,
    PhrygianMode.new,
    LydianMode.new,
    MixolydianMode.new,
    AeolianMode.new,
    LocrianMode.new
  ]

  def initialize(key)
    @key = key
  end

  def show_chords
  end

  def get_chord(roman_numeral_text)
    chord = ''
    is_minor = roman_numeral_text.downcase == roman_numeral_text
    is_diminished = roman_numeral_text.include?('°')
    is_augmented = roman_numeral_text.include?('+')
    is_flat = roman_numeral_text.include?('b')
    is_sharp = roman_numeral_text.include?('#')

    roman_numeral_text = roman_numeral_text.gsub(/[°+b#]/, '').strip

    chord = case roman_numeral_text.upcase
            when 'I'
              @key
            when 'II'
              get_interval(@key, 2)
            when 'III'
              get_interval(@key, 4)
            when 'IV'
              get_interval(@key, 5)
            when 'V'
              get_interval(@key, 7)
            when 'VI'
              get_interval(@key, 9)
            when 'VII'
              get_interval(@key, 11)
            else
              ''
            end

    if is_flat
      chord += 'b'
      if chord == 'Cb'
        chord = 'B'
      elsif chord == 'Fb'
        chord = 'E'
      end
    end

    if is_sharp
      chord += '#'
      if chord == 'B#'
        chord = 'C'
      elsif chord == 'E#'
        chord = 'F'
      end
    end

    chord += 'm' if is_minor
    chord += '°' if is_diminished
    chord += '+' if is_augmented

    chord
  end

  def get_interval(key, interval)
    index = SHARP_KEYS.index(key)
    index += interval - 1
    index -= 12 if index >= 12

    SHARP_KEYS[index]
  end

  def get_chord_notes(chord)
    chord_notes = []
    original_root_note = sanitize_chord(chord)

    root_note = get_root_note(chord)
    root_note_index = keys.index(root_note)

    chord_notes << keys[root_note_index]
    chord_notes << get_second_note_for_chord(chord, root_note_index)
    chord_notes << get_third_note_for_chord(chord, root_note_index)

    chord_notes[0] = original_root_note
    chord_notes.join(' - ')
  end

  def get_root_note(chord)
    sanitize_chord(chord).gsub('G#', 'Ab').gsub('A#', 'Bb').gsub('D#', 'Eb')
  end

  def sanitize_chord(chord)
    chord.gsub(/[m°+]/, '')
  end

  def get_second_note_for_chord(chord, root_note_index)
    if chord.include?('m') || chord.include?('°')
      keys[(root_note_index + 3) % 12]
    else
      keys[(root_note_index + 4) % 12]
    end
  end

  def get_third_note_for_chord(chord, root_note_index)
    if chord.include?('°')
      keys[(root_note_index + 6) % 12]
    elsif chord.include?('+')
      keys[(root_note_index + 8) % 12]
    else
      keys[(root_note_index + 7) % 12]
    end
  end
end
