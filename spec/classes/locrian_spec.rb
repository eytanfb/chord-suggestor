require 'rails_helper'

describe 'Locrian' do
  describe '#chord_shapes' do
    it 'returns an array of chord shapes' do
      expect(Locrian.new.chord_shapes.map(&:quality)).to eq(
        ['Diminished', 'Flat Major', 'Flat Minor', 'Minor', 'Flat Major',
         'Flat Major', 'Flat Minor']
      )
    end

    describe 'when is_seventh is true' do
      it 'returns an array of chord shapes' do
        expect(Locrian.new(is_seventh: true).chord_shapes.map(&:quality)).to eq(
          ['Half Diminished 7', 'Flat Major 7', 'Minor 7', 'Minor 7', 'Flat Major 7',
           'Dominant 7', 'Minor 7']
        )
      end
    end
  end

  describe '#intervals' do
    it 'returns an array of intervals' do
      expect(Locrian.new.intervals).to eq([0, 1, 3, 5, 6, 8, 10])
    end
  end
end
