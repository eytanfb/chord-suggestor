class Aeolian < Mode
  CHORD_SHAPES = %w[Minor Diminished Major Minor Minor Major Major].freeze

  def intervals
    [0, 2, 3, 5, 7, 8, 10]
  end

  def relative_major_interval
    3
  end
end
