require 'rails_helper'

describe 'Progression' do
  describe '#chords' do
    it 'returns the correct chords' do
      progression = [{ chord: 'Am', mode: 'Ionian' }]
      expect(Progression.new(progression).chords).to eq [{ chord: 'Am', mode: 'Ionian' }]
    end
  end

  describe '#add_chord' do
    it 'adds the chord to the progression' do
      progression = Progression.new([{ chord: 'Am', mode: 'Ionian' }])
      progression.add_chord('C', 'Ionian')
      expect(progression.chords).to eq [{ chord: 'Am', mode: 'Ionian' }, { chord: 'C', mode: 'Ionian' }]
    end
  end
end
