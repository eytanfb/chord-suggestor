class Locrian < Mode
  CHORD_SHAPES = ['Diminished', 'Flat Major', 'Flat Minor', 'Minor', 'Flat Major', 'Flat Major', 'Flat Minor'].freeze
  SEVENTH_CHORD_SHAPES = ['Half Diminished 7', 'Flat Major 7', 'Minor 7', 'Minor 7', 'Flat Major 7',
                          'Dominant 7', 'Minor 7'].freeze

  def intervals
    [0, 1, 3, 5, 6, 8, 10]
  end
end
