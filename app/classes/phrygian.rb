class Phrygian < Mode
  CHORD_SHAPES = ['Minor', 'Flat Major', 'Flat Major', 'Minor', 'Diminished', 'Flat Major', 'Flat Minor'].freeze

  def intervals
    [0, 1, 3, 5, 7, 8, 10]
  end
end
