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
  end

  describe '#intervals' do
    it 'returns an array of intervals' do
      expect(dorian.intervals).to eq([0, 2, 3, 5, 7, 9, 10])
    end
  end
end
