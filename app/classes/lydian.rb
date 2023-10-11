class Lydian < Mode
  CHORD_SHAPES = ['Major', 'Major', 'Minor', 'Sharp Minor Diminished', 'Major', 'Minor', 'Minor'].freeze

  def intervals
    [0, 2, 4, 6, 7, 9, 11]
  end
end
