class Dorian < Mode
  CHORD_SHAPES = ['Minor', 'Minor', 'Flat Major', 'Major', 'Minor', 'Diminished', 'Flat Major'].freeze
  SEVENTH_CHORD_SHAPES = ['Minor 7', 'Minor 7', 'Flat Major 7', 'Dominant 7', 'Minor 7', 'Diminished 7',
                          'Major 7'].freeze

  def intervals
    [0, 2, 3, 5, 7, 9, 10]
  end
end
