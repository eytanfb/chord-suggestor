class Progression
  def initialize(progression)
    @progression = progression
  end

  def chord_groups
    @progression
  end

  def add_chord_group(chord_group, mode)
    @progression << { chord_group:, mode: }
  end

  def add_silence
    @progression << { chord_group: ChordGroup.new(SilentChord.new), mode: 'Silence' }
  end

  def ==(other)
    return false unless @progression == other.chord_groups

    true
  end

  def self.from_json(json)
    progression = Progression.new([])

    json.each do |chord_group_json|
      isSilence = chord_group_json['chord_group']['primary_chord']['name'] == 'Silence'

      if isSilence
        progression.add_silence
      else
        chord_group = ChordGroup.from_json(chord_group_json['chord_group'])
        mode = chord_group_json['mode']
        progression.add_chord_group(chord_group, mode)
      end
    end

    progression
  end
end
