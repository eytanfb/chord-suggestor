require 'rails_helper'

describe 'Dorian' do
  let(:dorian) { Dorian.new }

  describe '#chord_shapes' do
    it 'returns an array of chord shapes' do
      expect(dorian.chord_shapes.map(&:quality)).to eq(
        ['Minor', 'Minor', 'Flat Major', 'Major', 'Minor',
         'Diminished', 'Flat Major']
      )
    end

    describe 'when is_seventh is true' do
      let(:dorian) { Dorian.new(is_seventh: true) }
      it 'returns an array of chord shapes' do
        expect(dorian.chord_shapes.map(&:quality)).to eq(
          ['Minor 7', 'Minor 7', 'Flat Major 7', 'Dominant 7', 'Minor 7',
           'Diminished 7', 'Major 7']
        )
      end
    end
  end

  describe '#intervals' do
    it 'returns an array of intervals' do
      expect(dorian.intervals).to eq([0, 2, 3, 5, 7, 9, 10])
    end
  end
end
