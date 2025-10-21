class Aeolian < Mode
  CHORD_SHAPES = ['Minor', 'Diminished', 'Major', 'Minor', 'Minor', 'Major', 'Major'].freeze
  SEVENTH_CHORD_SHAPES = ['Minor 7', 'Half Diminished 7', 'Major 7', 'Minor 7', 'Minor 7', 'Major 7',
                          'Dominant 7'].freeze

  def intervals
    [0, 2, 3, 5, 7, 8, 10]
  end

  def relative_major_interval
    3
  end
end
