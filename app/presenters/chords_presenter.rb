class ChordsPresenter
  MODES_ORDER = {
    'Lydian' => 1,
    'Ionian' => 2,
    'Mixolydian' => 3,
    'Dorian' => 4,
    'Aeolian' => 5,
    'Phrygian' => 6,
    'Locrian' => 7
  }.freeze

  DEGREE_ORDER = {
    'Ionian' => 1,
    'Dorian' => 2,
    'Phrygian' => 3,
    'Lydian' => 4,
    'Mixolydian' => 5,
    'Aeolian' => 6,
    'Locrian' => 7
  }.freeze

  def initialize(chords)
    @chords = chords
  end

  def present(order_by: :mode)
    case order_by
    when :mode
      order_by_mode
    when :degree
      order_by_degree
    else
      raise ArgumentError, "Unknown order_by: #{order_by}"
    end
  end

  def order_by_mode
    @chords.sort_by do |chord|
      MODES_ORDER[chord[0]]
    end
  end

  def order_by_degree
    @chords.sort_by do |chord|
      DEGREE_ORDER[chord[0]]
    end
  end
end
