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
    'Flat Minor' => [0, 3, 7],
    'Major 7' => [0, 4, 7, 11],
    'Flat Major 7' => [0, 4, 7, 11],
    'Minor 7' => [0, 3, 7, 10],
    'Dominant 7' => [0, 4, 7, 10],
    'Diminished 7' => [0, 3, 6, 9],
    'Half Diminished 7' => [0, 3, 6, 10],
    'Augmented 7' => [0, 4, 8, 10],
    'Minor 7 Flat 5' => [0, 3, 6, 10],
    'Major 6' => [0, 4, 7, 9],
    'Minor 6' => [0, 3, 7, 9]
  }.freeze

  QUALITY_REPRESENTATIONS = {
    'Major' => '',
    'Minor' => 'm',
    'Diminished' => '°',
    'Augmented' => '+',
    'Minor Diminished' => 'm°',
    'Sharp Minor Diminished' => 'm°',
    'Flat Major' => '',
    'Flat Minor' => 'm',
    'Major 7' => 'maj7',
    'Flat Major 7' => 'maj7',
    'Minor 7' => 'm7',
    'Dominant 7' => '7',
    'Diminished 7' => '°7',
    'Half Diminished 7' => 'ø7',
    'Augmented 7' => '+7',
    'Minor 7 Flat 5' => 'm7b5',
    'Major 6' => 'maj6',
    'Minor 6' => 'm6'
  }.freeze

  QUALITY_REPRESENTATIONS_INVERSE = {
    'maj7' => 'Major 7',
    'm7' => 'Minor 7',
    '7' => 'Dominant 7',
    '°7' => 'Diminished 7',
    'ø7' => 'Half Diminished 7',
    '+7' => 'Augmented 7',
    'm7b5' => 'Minor 7 Flat 5',
    'maj6' => 'Major 6',
    'm6' => 'Minor 6',
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

  def self.from_json(json)
    quality = json['quality']
    ChordShape.new(quality)
  end
end
