class Chord
  attr_reader :notes, :name

  def initialize(root, chord_shape)
    @root = root
    @chord_shape = chord_shape
    @notes = []
    @name = "#{root.name}#{chord_shape.quality_representation}"

    @chord_shape.intervals.each do |interval|
      @notes << @root.up(interval)
    end
  end

  def quality
    @chord_shape.quality
  end

  def ==(other)
    @notes == other.notes
  end

  def display_joined_notes
    @notes.map(&:name).join(' - ')
  end

  def note_samples
    @notes.map(&:sample_for_note)
  end

  def minor?
    quality == 'm'
  end

  def self.silence
    SilentChord.new
  end

  def self.from_json(json)
    root = Note.from_json(json['root'])
    chord_shape = ChordShape.from_json(json['chord_shape'])

    Chord.new(root, chord_shape)
  end
end
