require 'rails_helper'

describe 'Progression' do
  let(:chord_group) do
    ChordGroup.new(Chord.new(Note.new('A'), ChordShape.new('Major')))
  end

  let(:progression) do
    Progression.new([{ chord_group:, mode: 'Ionian' }])
  end

  describe '#chord_groups' do
    it 'returns the correct chord_groups' do
      expect(progression.chord_groups).to eq [{ chord_group:, mode: 'Ionian' }]
    end
  end

  describe '#add_chord_group' do
    it 'adds the chord_group to the progression' do
      new_chord_group = ChordGroup.new(Chord.new(Note.new('Am'), ChordShape.new('Minor')))
      progression.add_chord_group(new_chord_group, 'Dorian')
      expect(progression.chord_groups).to eq [{ chord_group:, mode: 'Ionian' },
                                              { chord_group: new_chord_group, mode: 'Dorian' }]
    end
  end

  describe '#add_silence' do
    let(:silent_chord_group) do
      ChordGroup.new(SilentChord.new)
    end

    it 'adds a silence to the progression' do
      progression.add_silence
      expect(progression.chord_groups).to eq [{ chord_group:, mode: 'Ionian' },
                                              { chord_group: silent_chord_group, mode: 'Silence' }]
    end
  end

  describe '.from_json' do
    let(:json) do
      [{ 'chord_group' => { 'primary_chord' => { 'root' => { 'name' => 'A' }, 'chord_shape' => { 'quality' => 'Major' } },
                            'alternative_chords' => [] },
         'mode' => 'Ionian' }]
    end

    it 'returns a progression' do
      expect(Progression.from_json(json)).to eq(progression)
    end
  end
end
