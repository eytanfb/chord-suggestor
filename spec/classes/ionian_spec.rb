require 'rails_helper'

describe 'Ionian' do
  describe '#initialize' do
    it 'returns an Ionian object' do
      expect(Ionian.new).to be_a(Ionian)
    end
  end

  describe '#chord_shapes' do
    it 'returns an array of chord shapes' do
      expect(Ionian.new.chord_shapes.map(&:quality)).to eq(
        %w[Major Minor Minor Major Major Minor Diminished]
      )
    end

    describe 'when is_seventh is true' do
      it 'returns an array of chord shapes' do
        expect(Ionian.new.chord_shapes(is_seventh: true).map(&:quality)).to eq(
          ['Major 7', 'Minor 7', 'Minor 7', 'Major 7', 'Dominant 7', 'Minor 7', 'Diminished 7']
        )
      end
    end
  end

  describe '#intervals' do
    it 'returns an array of intervals' do
      expect(Ionian.new.intervals).to eq([0, 2, 4, 5, 7, 9, 11])
    end
  end
end
