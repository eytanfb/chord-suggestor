class Scale
  attr_reader :notes

  SHARP_SCALES = ['C', 'G', 'D', 'A', 'E', 'B', 'F#', 'Gb'].freeze
  FLAT_SCALES  = ['F', 'Bb', 'Eb', 'Ab', 'Db', 'C#', 'A#', 'D#', 'G#'].freeze

  def initialize(key, mode)
    @notes = []
    @key = key
    @mode = mode

    mode.intervals.each do |interval|
      current_note = get_current_note_for_interval(interval)
      @notes << current_note
    end
  end

  def chord_groups
    @notes.map.with_index do |note, index|
      chord = Chord.new(note, @mode.chord_shape_at(index))
      ChordGroup.new(chord)
    end
  end

  def name
    "#{@key.name} #{@mode.name}"
  end

  private

  def get_current_note_for_interval(interval)
    current_note = @key.up(interval)

    if @key.flat?
      current_note = Note.flat_version(current_note)
    elsif @key.sharp?
      current_note = Note.sharp_version(current_note)
    end

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
