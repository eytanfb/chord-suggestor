class Locrian < Mode
  CHORD_SHAPES = ['Diminished', 'Flat Major', 'Flat Minor', 'Minor', 'Flat Major', 'Flat Major', 'Flat Minor'].freeze

  def intervals
    [0, 1, 3, 5, 6, 8, 10]
  end
end
