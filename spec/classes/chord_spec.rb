require 'rails_helper'

describe 'Chord' do
  describe '#initialize' do
    it 'creates a chord with the correct notes' do
      chord = Chord.new(Note.new('C'), Note.new('C'), ChordShape.new('Major'))
      expect(chord.notes).to eq [Note.new('C'), Note.new('E'), Note.new('G')]
    end
  end

  describe '#name' do
    it 'returns the correct name for a major chord' do
      chord = Chord.new(Note.new('C'), Note.new('C'), ChordShape.new('Major'))
      expect(chord.name).to eq 'C'
    end

    it 'returns the correct name for a minor chord' do
      chord = Chord.new(Note.new('A'), Note.new('A'), ChordShape.new('Minor'))
      expect(chord.name).to eq 'Am'
    end
  end

  describe '#quality' do
    it 'returns the correct quality for a major chord' do
      chord = Chord.new(Note.new('C'), Note.new('C'), ChordShape.new('Major'))
      expect(chord.quality).to eq 'Major'
    end

    it 'returns the correct quality for a minor chord' do
      chord = Chord.new(Note.new('A'), Note.new('A'), ChordShape.new('Minor'))
      expect(chord.quality).to eq 'Minor'
    end
  end
end
