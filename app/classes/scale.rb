class Scale
  attr_reader :notes

  SHARP_SCALES = ['C', 'G', 'D', 'A', 'E', 'B', 'F#', 'Gb'].freeze
  FLAT_SCALES  = ['F', 'Bb', 'Eb', 'Ab', 'Db', 'C#', 'A#', 'D#', 'G#'].freeze

  def initialize(key, mode)
    @notes = []
    @key = key
    @mode = mode

    mode.intervals.each do |interval|
      current_note = get_current_note_for_interval(key, interval)
      @notes << current_note
    end
  end

  def chords
    @notes.map.with_index do |note, index|
      Chord.new(note, @key, @mode.chord_shape_at(index))
    end
  end

  def name
    "#{@key.name} #{@mode.name}"
  end

  private

  def get_current_note_for_interval(key, interval)
    current_note = key.up(interval)
    current_note = key.flat? ? Note.flat_version(current_note) : Note.sharp_version(current_note)

    return current_note if @notes.empty?

    current_note = handle_same_letter_name(current_note)
    handle_not_successive(current_note)
  end

  def handle_same_letter_name(note)
    if @notes.last.name[0] == note.name[0]
      flat_note = Note.flat_version(note.up(1))
      flat_note.flatten_without_interval
    else
      note
    end
  end

  def handle_not_successive(note)
    if !@notes.last.successive_to?(note)
      sharp_note = Note.sharp_version(note.down(1))
      sharp_note.sharpen_without_interval
    else
      note
    end
  end
end
