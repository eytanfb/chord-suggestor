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

  def initialize(chords)
    @chords = chords
  end

  def present
    @chords.sort_by do |chord|
      MODES_ORDER[chord[0]]
    end
  end
end
