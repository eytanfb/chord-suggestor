class ChordShape
  attr_reader :quality

  INTERVALS = {
    'Major' => [0, 4, 7],
    'Minor' => [0, 3, 7],
    'Diminished' => [0, 3, 6],
    'Augmented' => [0, 4, 8],
    'Minor Diminished' => [0, 3, 6],
    'Sharp Minor Diminished' => [0, 3, 6],
    'Flat Major' => [0, 4, 7],
    'Flat Minor' => [0, 3, 7]
  }.freeze

  QUALITY_REPRESENTATIONS = {
    'Major' => '',
    'Minor' => 'm',
    'Diminished' => '°',
    'Augmented' => '+',
    'Minor Diminished' => 'm°',
    'Sharp Minor Diminished' => 'm°',
    'Flat Major' => '',
    'Flat Minor' => 'm'
  }.freeze

  QUALITY_REPRESENTATIONS_INVERSE = {
    '' => 'Major',
    'm' => 'Minor',
    '°' => 'Diminished',
    '+' => 'Augmented',
    'm°' => 'Minor Diminished'
  }.freeze

  def initialize(quality)
    @quality = quality
  end

  def intervals
    INTERVALS[@quality]
  end

  def quality_representation
    QUALITY_REPRESENTATIONS[@quality]
  end
end
