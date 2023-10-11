require 'rails_helper'

describe 'Chord' do
  describe '#initialize' do
    it 'creates a chord with the correct notes' do
      chord = Chord.new(Note.new('C'), Note.new('C'), ChordShape.new('Major'))
      expect(chord.notes).to eq [Note.new('C'), Note.new('E'), Note.new('G')]
    end
  end

  describe '#notes' do
    it 'returns the correct notes for a major chord' do
      chord = Chord.new(Note.new('C'), Note.new('C'), ChordShape.new('Major'))
      expect(chord.notes).to eq [Note.new('C'), Note.new('E'), Note.new('G')]
    end

    it 'returns the correct notes for a minor chord' do
      chord = Chord.new(Note.new('A'), Note.new('A'), ChordShape.new('Minor'))
      expect(chord.notes).to eq [Note.new('A'), Note.new('C'), Note.new('E')]
    end

    it 'returns the correct notes for a diminished chord' do
      chord = Chord.new(Note.new('B'), Note.new('B'), ChordShape.new('Diminished'))
      expect(chord.notes).to eq [Note.new('B'), Note.new('D'), Note.new('F')]
    end

    it 'returns the correct notes for an augmented chord' do
      chord = Chord.new(Note.new('C'), Note.new('C'), ChordShape.new('Augmented'))
      expect(chord.notes).to eq [Note.new('C'), Note.new('E'), Note.new('G#')]
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
