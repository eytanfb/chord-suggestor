require 'rails_helper'

describe 'Lydian' do
  describe '#chord_shapes' do
    it 'returns an array of chord shapes' do
      expect(Lydian.new.chord_shapes.map(&:quality)).to eq(
        ['Major', 'Major', 'Minor', 'Sharp Minor Diminished', 'Major', 'Minor',
         'Minor']
      )
    end

    describe 'when is_seventh is true' do
      it 'returns an array of chord shapes' do
        expect(Lydian.new(is_seventh: true).chord_shapes.map(&:quality)).to eq(
          ['Major 7', 'Dominant 7', 'Minor 7', 'Half Diminished 7', 'Major 7', 'Minor 7',
           'Minor 7']
        )
      end
    end
  end

  describe '#intervals' do
    it 'returns an array of intervals' do
      expect(Lydian.new.intervals).to eq([0, 2, 4, 6, 7, 9, 11])
    end
  end
end
