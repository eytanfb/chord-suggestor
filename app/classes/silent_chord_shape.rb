class SilentChordShape < ChordShape
  attr_reader :intervals, :quality, :quality_representation

  def initialize
    @intervals = []
    @quality = 'Silence'
    @quality_representation = ''
  end
end
