class Mode
  ALL = %w[Ionian Dorian Phrygian Lydian Mixolydian Aeolian Locrian].freeze

  def initialize(is_seventh: false)
    @is_seventh = is_seventh
  end

  def chord_shapes
    @chord_shapes ||= if @is_seventh
                        self.class::SEVENTH_CHORD_SHAPES.map { |shape| ChordShape.new(shape) }
                      else
                        self.class::CHORD_SHAPES.map { |shape| ChordShape.new(shape) }
                      end
  end

  def chord_shape_at(index)
    chord_shapes[index]
  end

  def name
    self.class.to_s
  end
end
