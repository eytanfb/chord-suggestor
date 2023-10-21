require 'rails_helper'

describe 'Aeolian' do
  describe '#chord_shapes' do
    it 'returns an array of chord shapes' do
      aeolian = Aeolian.new
      expect(aeolian.chord_shapes.map(&:quality)).to eq(
        %w[
          Minor
          Diminished
          Major
          Minor
          Minor
          Major
          Major
        ]
      )
    end

    describe 'when is_seventh is true' do
      it 'returns an array of chord shapes' do
        aeolian = Aeolian.new(is_seventh: true)
        expect(aeolian.chord_shapes.map(&:quality)).to eq(
          [
            'Minor 7',
            'Half Diminished 7',
            'Major 7',
            'Minor 7',
            'Minor 7',
            'Major 7',
            'Dominant 7'
          ]
        )
      end
    end
  end

  describe '#intervals' do
    it 'returns an array of intervals' do
      aeolian = Aeolian.new
      expect(aeolian.intervals).to eq([0, 2, 3, 5, 7, 8, 10])
    end
  end

  describe '#relative_major_interval' do
    it 'returns the correct interval' do
      aeolian = Aeolian.new
      expect(aeolian.relative_major_interval).to eq(3)
    end
  end
end
