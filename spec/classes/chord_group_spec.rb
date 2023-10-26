require 'rails_helper'

describe 'ChordGroup' do
  describe '#initialize' do
    it 'creates a chord group with a primary chord' do
      chord = Chord.new(Note.new('C'), ChordShape.new('Major'))
      chord_group = ChordGroup.new(chord)

      expect(chord_group.primary_chord).to eq(chord)
    end

    it 'creates a chord group with an empty list of alternative chords' do
      chord = Chord.new(Note.new('C'), ChordShape.new('Major'))
      chord_group = ChordGroup.new(chord)

      expect(chord_group.alternative_chords).to eq([])
    end
  end

  describe '#add_alternative' do
    it 'adds a chord to the list of alternative chords' do
      chord = Chord.new(Note.new('C'), ChordShape.new('Major'))
      chord_group = ChordGroup.new(chord)

      chord_group.add_alternative(Chord.new(Note.new('C'), ChordShape.new('Major')))

      expect(chord_group.alternative_chords.count).to eq(1)
    end
  end

  describe '#==' do
    it 'returns true when the primary chord and alternative chords are equal' do
      chord = Chord.new(Note.new('C'), ChordShape.new('Major'))
      chord_group = ChordGroup.new(chord)
      chord_group.add_alternative(Chord.new(Note.new('C'), ChordShape.new('Major')))

      other_chord = Chord.new(Note.new('C'), ChordShape.new('Major'))
      other_chord_group = ChordGroup.new(other_chord)
      other_chord_group.add_alternative(Chord.new(Note.new('C'), ChordShape.new('Major')))

      expect(chord_group).to eq(other_chord_group)
    end

    it 'returns false when the primary chord is different' do
      chord = Chord.new(Note.new('C'), ChordShape.new('Major'))
      chord_group = ChordGroup.new(chord)
      chord_group.add_alternative(Chord.new(Note.new('C'), ChordShape.new('Major')))

      other_chord = Chord.new(Note.new('D'), ChordShape.new('Major'))
      other_chord_group = ChordGroup.new(other_chord)
      other_chord_group.add_alternative(Chord.new(Note.new('C'), ChordShape.new('Major')))

      expect(chord_group).not_to eq(other_chord_group)
    end

    it 'returns false when the alternative chords are different' do
      chord = Chord.new(Note.new('C'), ChordShape.new('Major'))
      chord_group = ChordGroup.new(chord)
      chord_group.add_alternative(Chord.new(Note.new('C'), ChordShape.new('Major')))

      other_chord = Chord.new(Note.new('C'), ChordShape.new('Major'))
      other_chord_group = ChordGroup.new(other_chord)
      other_chord_group.add_alternative(Chord.new(Note.new('D'), ChordShape.new('Major')))

      expect(chord_group).not_to eq(other_chord_group)
    end
  end
end
