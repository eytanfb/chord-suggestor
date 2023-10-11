class Mixolydian < Mode
  CHORD_SHAPES = ['Major', 'Minor', 'Minor Diminished', 'Major', 'Minor', 'Minor', 'Flat Major'].freeze

  def intervals
    [0, 2, 4, 5, 7, 9, 10]
  end
end
