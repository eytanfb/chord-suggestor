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

    describe 'when is_seventh is true' do
      it 'returns an array of chord shapes' do
        expect(Phrygian.new(is_seventh: true).chord_shapes.map(&:quality)).to eq(
          [
            'Minor 7',
            'Flat Major 7',
            'Dominant 7',
            'Minor 7',
            'Half Diminished 7',
            'Flat Major 7',
            'Minor 7'
          ]
        )
      end
    end
  end

  describe '#intervals' do
    it 'returns an array of intervals' do
      expect(Phrygian.new.intervals).to eq([0, 1, 3, 5, 7, 8, 10])
    end
  end
end
