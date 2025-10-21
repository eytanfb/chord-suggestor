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

  def present(order_by: :mode, perspective: :primary)
    ordered_chords = case order_by
    when :mode
      order_by_mode
    when :degree
      order_by_degree
    else
      raise ArgumentError, "Unknown order_by: #{order_by}"
    end

    apply_perspective(ordered_chords, perspective)
  end

  private

  def order_by_mode
    @chords.sort_by { |chord| MODES_ORDER[chord[0]] }
  end

  def order_by_degree
    @chords.sort_by { |chord| DEGREE_ORDER[chord[0]] }
  end

  def apply_perspective(chords, perspective)
    return chords if perspective == :primary

    chords.map do |mode, chord_groups|
      transformed_groups = chord_groups.map.with_index do |chord_group, index|
        select_chord_by_perspective(chord_group, index, perspective)
      end

      [mode, transformed_groups]
    end
  end

  def select_chord_by_perspective(chord_group, index, perspective)
    # Indices 0, 3, 6 (I, IV, VII) have no alternatives
    return chord_group if [0, 3, 6].include?(index)

    case perspective
    when :secondary_dominants
      # Use first alternative (V/x) if available
      if chord_group.alternative_chords.any?
        secondary_dominant = chord_group.alternative_chords[0]
        ChordGroup.new(secondary_dominant)
      else
        chord_group
      end
    when :diminished_approaches
      # Use second alternative (vii°/x) if available
      if chord_group.alternative_chords.length > 1
        diminished_approach = chord_group.alternative_chords[1]
        ChordGroup.new(diminished_approach)
      else
        chord_group
      end
    else
      chord_group
    end
  end
end
