class Mode
  def chord_shapes
    @chord_shapes ||= self.class::CHORD_SHAPES.map { |shape| ChordShape.new(shape) }
  end

  def chord_shape_at(index)
    chord_shapes[index]
  end

  def name
    self.class.to_s
  end
end