require 'rails_helper'

describe ChordShape do
  describe '#initialize' do
    it 'creates a chord shape with the correct intervals' do
      chord_shape = ChordShape.new('Major')
      expect(chord_shape.intervals).to eq [0, 4, 7]
    end
  end

  describe '#quality' do
    it 'returns the correct quality for a major chord shape' do
      chord_shape = ChordShape.new('Major')
      expect(chord_shape.quality).to eq 'Major'
    end

    it 'returns the correct quality for a minor chord shape' do
      chord_shape = ChordShape.new('Minor')
      expect(chord_shape.quality).to eq 'Minor'
    end
  end

  describe '#intervals' do
    it 'returns the correct intervals for a major chord shape' do
      chord_shape = ChordShape.new('Major')
      expect(chord_shape.intervals).to eq [0, 4, 7]
    end

    it 'returns the correct intervals for a minor chord shape' do
      chord_shape = ChordShape.new('Minor')
      expect(chord_shape.intervals).to eq [0, 3, 7]
    end

    it 'returns the correct intervals for a diminished chord shape' do
      chord_shape = ChordShape.new('Diminished')
      expect(chord_shape.intervals).to eq [0, 3, 6]
    end

    it 'returns the correct intervals for an augmented chord shape' do
      chord_shape = ChordShape.new('Augmented')
      expect(chord_shape.intervals).to eq [0, 4, 8]
    end

    it 'returns the correct intervals for a minor diminished chord shape' do
      chord_shape = ChordShape.new('Minor Diminished')
      expect(chord_shape.intervals).to eq [0, 3, 6]
    end

    it 'returns the correct intervals for a sharp minor diminished chord shape' do
      chord_shape = ChordShape.new('Sharp Minor Diminished')
      expect(chord_shape.intervals).to eq [0, 3, 6]
    end

    it 'returns the correct intervals for a flat major chord shape' do
      chord_shape = ChordShape.new('Flat Major')
      expect(chord_shape.intervals).to eq [0, 4, 7]
    end

    it 'returns the correct intervals for a flat minor chord shape' do
      chord_shape = ChordShape.new('Flat Minor')
      expect(chord_shape.intervals).to eq [0, 3, 7]
    end
  end
end
