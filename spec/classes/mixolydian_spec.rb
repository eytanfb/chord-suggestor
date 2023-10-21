require 'rails_helper'

describe 'Mixolydian' do
  describe '#chord_shapes' do
    it 'returns an array of chord shapes' do
      expect(Mixolydian.new.chord_shapes.map(&:quality)).to eq(
        [
          'Major',
          'Minor',
          'Minor Diminished',
          'Major',
          'Minor',
          'Minor',
          'Flat Major'
        ]
      )
    end

    describe 'when is_seventh is true' do
      it 'returns an array of chord shapes' do
        expect(Mixolydian.new(is_seventh: true).chord_shapes.map(&:quality)).to eq(
          [
            'Dominant 7',
            'Minor 7',
            'Half Diminished 7',
            'Major 7',
            'Minor 7',
            'Minor 7',
            'Flat Major 7'
          ]
        )
      end
    end
  end

  describe '#intervals' do
    it 'returns an array of intervals' do
      expect(Mixolydian.new.intervals).to eq([0, 2, 4, 5, 7, 9, 10])
    end
  end
end
