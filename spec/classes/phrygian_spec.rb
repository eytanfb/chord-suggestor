require 'rails_helper'

describe 'Phrygian' do
  describe '#chord_shapes' do
    it 'returns an array of chord shapes' do
      expect(Phrygian.new.chord_shapes.map(&:quality)).to eq(
        [
          'Minor',
          'Flat Major',
          'Flat Major',
          'Minor',
          'Diminished',
          'Flat Major',
          'Flat Minor'
        ]
      )
    end
  end

  describe '#intervals' do
    it 'returns an array of intervals' do
      expect(Phrygian.new.intervals).to eq([0, 1, 3, 5, 7, 8, 10])
    end
  end
end
