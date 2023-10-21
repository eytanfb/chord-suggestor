class Lydian < Mode
  CHORD_SHAPES = ['Major', 'Major', 'Minor', 'Sharp Minor Diminished', 'Major', 'Minor', 'Minor'].freeze
  SEVENTH_CHORD_SHAPES = ['Major 7', 'Dominant 7', 'Minor 7', 'Half Diminished 7', 'Major 7', 'Minor 7',
                          'Minor 7'].freeze

  def intervals
    [0, 2, 4, 6, 7, 9, 11]
  end
end
