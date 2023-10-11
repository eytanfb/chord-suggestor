require 'rails_helper'

describe 'Lydian' do
  describe '#chord_shapes' do
    it 'returns an array of chord shapes' do
      expect(Lydian.new.chord_shapes.map(&:quality)).to eq(
        ['Major', 'Major', 'Minor', 'Sharp Minor Diminished', 'Major', 'Minor',
         'Minor']
      )
    end
  end

  describe '#intervals' do
    it 'returns an array of intervals' do
      expect(Lydian.new.intervals).to eq([0, 2, 4, 6, 7, 9, 11])
    end
  end
end
