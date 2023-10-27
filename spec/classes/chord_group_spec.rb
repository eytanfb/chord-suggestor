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

    describe 'when chord is silent' do
      it 'returns true when the primary chord and alternative chords are equal' do
        chord = SilentChord.new
        chord_group = ChordGroup.new(chord)
        chord_group.add_alternative(SilentChord.new)

        other_chord = SilentChord.new
        other_chord_group = ChordGroup.new(other_chord)
        other_chord_group.add_alternative(SilentChord.new)

        expect(chord_group).to eq(other_chord_group)
      end

      it 'returns false when the primary chord is different' do
        chord = SilentChord.new
        chord_group = ChordGroup.new(chord)
        chord_group.add_alternative(SilentChord.new)

        other_chord = Chord.new(Note.new('D'), ChordShape.new('Major'))
        other_chord_group = ChordGroup.new(other_chord)
        other_chord_group.add_alternative(SilentChord.new)

        expect(chord_group).not_to eq(other_chord_group)
      end

      it 'returns false when the alternative chords are different' do
        chord = SilentChord.new
        chord_group = ChordGroup.new(chord)
        chord_group.add_alternative(SilentChord.new)

        other_chord = SilentChord.new
        other_chord_group = ChordGroup.new(other_chord)
        other_chord_group.add_alternative(Chord.new(Note.new('D'), ChordShape.new('Major')))

        expect(chord_group).not_to eq(other_chord_group)
      end
    end
  end

  describe '.from_json' do
    it 'creates a chord group from a json string' do
      json = {
        'primary_chord' => { 'root' => { 'name' => 'C' }, 'chord_shape' => { 'quality' => 'Major 7' },
                             'notes' => [{ 'name' => 'C' }, { 'name' => 'E' }, { 'name' => 'G' }, { 'name' => 'B' }], 'name' => 'Cmaj7' }, 'alternative_chords' => []
      }

      other_chord_group = ChordGroup.from_json(json)

      expect(json.to_json).to eq(other_chord_group.to_json)
    end
  end
end
