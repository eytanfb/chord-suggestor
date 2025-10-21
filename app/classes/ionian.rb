class Ionian < Mode
  CHORD_SHAPES = ['Major', 'Minor', 'Minor', 'Major', 'Major', 'Minor', 'Diminished'].freeze
  SEVENTH_CHORD_SHAPES = ['Major 7', 'Minor 7', 'Minor 7', 'Major 7', 'Dominant 7', 'Minor 7', 'Diminished 7'].freeze

  def intervals
    [0, 2, 4, 5, 7, 9, 11]
  end
end
