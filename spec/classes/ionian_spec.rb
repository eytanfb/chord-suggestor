require 'rails_helper'

describe 'Ionian' do
  describe '#chord_shapes' do
    it 'returns an array of chord shapes' do
      expect(Ionian.new.chord_shapes.map(&:quality)).to eq(
        %w[Major Minor Minor Major Major Minor Diminished]
      )
    end
  end

  describe '#intervals' do
    it 'returns an array of intervals' do
      expect(Ionian.new.intervals).to eq([0, 2, 4, 5, 7, 9, 11])
    end
  end
end
