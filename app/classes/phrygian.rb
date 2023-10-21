class Phrygian < Mode
  CHORD_SHAPES = ['Minor', 'Flat Major', 'Flat Major', 'Minor', 'Diminished', 'Flat Major', 'Flat Minor'].freeze
  SEVENTH_CHORD_SHAPES = ['Minor 7', 'Flat Major 7', 'Dominant 7', 'Minor 7', 'Half Diminished 7', 'Flat Major 7',
                          'Minor 7'].freeze

  def intervals
    [0, 1, 3, 5, 7, 8, 10]
  end
end
