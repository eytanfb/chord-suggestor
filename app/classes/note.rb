class Note
  SEMITONES = {
    'C' => 0,
    'C#' => 1,
    'Db' => 1,
    'D' => 2,
    'D#' => 3,
    'Eb' => 3,
    'E' => 4,
    'F' => 5,
    'F#' => 6,
    'Gb' => 6,
    'G' => 7,
    'G#' => 8,
    'Ab' => 8,
    'A' => 9,
    'A#' => 10,
    'Bb' => 10,
    'B' => 11
  }.freeze

  attr_reader :name

  def initialize(name)
    @name = name
  end

  def semitones
    semitone = SEMITONES[@name]

    return semitone unless semitone.nil?

    # for every # in the note, add 1 semitone
    # for every b in the note, subtract 1 semitone
    semitone = 0
    @name.each_char do |char|
      semitone += 1 if char == '#'
      semitone -= 1 if char == 'b'
    end

    semitone
  end

  def up(interval)
    Note.new(Note::SEMITONES.key((semitones + interval) % 12))
  end

  def down(interval)
    Note.new(Note::SEMITONES.key((semitones - interval) % 12))
  end

  def flat?
    @name.include?('b')
  end

  def sharp?
    @name.include?('#')
  end

  def flatten_without_interval
    Note.new("#{@name}b")
  end

  def sharpen_without_interval
    Note.new("#{@name}#")
  end

  def successive_to?(note)
    note_ord = note.name.ord
    self_ord = @name.ord

    (self_ord - note_ord).abs % 5 == 1
  end

  def ==(other)
    @name == other.name
  end

  def self.sharp_version(note)
    return note unless note.name.include?('b')

    same_interval_notes = Note::SEMITONES.select do |_key, value|
      value == note.semitones
    end

    sharp_version = same_interval_notes.keys.find do |key|
      key.include?('#')
    end

    Note.new(sharp_version)
  end

  def self.flat_version(note)
    return note unless note.name.include?('#')

    same_interval_notes = Note::SEMITONES.select do |_key, value|
      value == note.semitones
    end

    flat_version = same_interval_notes.keys.find do |key|
      key.include?('b')
    end

    Note.new(flat_version)
  end
end
