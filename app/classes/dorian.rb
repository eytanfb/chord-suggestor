class Dorian < Mode
  CHORD_SHAPES = ['Minor', 'Minor', 'Flat Major', 'Major', 'Minor', 'Diminished', 'Flat Major'].freeze

  def intervals
    [0, 2, 3, 5, 7, 9, 10]
  end
end
