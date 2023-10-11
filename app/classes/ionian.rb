class Ionian < Mode
  CHORD_SHAPES = %w[Major Minor Minor Major Major Minor Diminished].freeze

  def intervals
    [0, 2, 4, 5, 7, 9, 11]
  end
end
