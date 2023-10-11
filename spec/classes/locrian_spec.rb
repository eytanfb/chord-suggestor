require 'rails_helper'

describe 'Locrian' do
  describe '#chord_shapes' do
    it 'returns an array of chord shapes' do
      expect(Locrian.new.chord_shapes.map(&:quality)).to eq(
        ['Diminished', 'Flat Major', 'Flat Minor', 'Minor', 'Flat Major',
         'Flat Major', 'Flat Minor']
      )
    end
  end

  describe '#intervals' do
    it 'returns an array of intervals' do
      expect(Locrian.new.intervals).to eq([0, 1, 3, 5, 6, 8, 10])
    end
  end
end
