class Mixolydian < Mode
  CHORD_SHAPES = ['Major', 'Minor', 'Minor Diminished', 'Major', 'Minor', 'Minor', 'Flat Major'].freeze
  SEVENTH_CHORD_SHAPES = ['Dominant 7', 'Minor 7', 'Half Diminished 7', 'Major 7', 'Minor 7', 'Minor 7',
                          'Flat Major 7'].freeze

  def intervals
    [0, 2, 4, 5, 7, 9, 10]
  end
end
