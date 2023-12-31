require 'rails_helper'

describe 'Chord' do
  describe '#initialize' do
    it 'creates a chord with the correct notes' do
      chord = Chord.new(Note.new('C'), ChordShape.new('Major'))
      expect(chord.notes).to eq [Note.new('C'), Note.new('E'), Note.new('G')]
    end
  end

  describe '#notes' do
    it 'returns the correct notes for a major chord' do
      chord = Chord.new(Note.new('C'), ChordShape.new('Major'))
      expect(chord.notes).to eq [Note.new('C'), Note.new('E'), Note.new('G')]
    end

    it 'returns the correct notes for a minor chord' do
      chord = Chord.new(Note.new('A'), ChordShape.new('Minor'))
      expect(chord.notes).to eq [Note.new('A'), Note.new('C'), Note.new('E')]
    end

    it 'returns the correct notes for a diminished chord' do
      chord = Chord.new(Note.new('B'), ChordShape.new('Diminished'))
      expect(chord.notes).to eq [Note.new('B'), Note.new('D'), Note.new('F')]
    end

    it 'returns the correct notes for an augmented chord' do
      chord = Chord.new(Note.new('C'), ChordShape.new('Augmented'))
      expect(chord.notes).to eq [Note.new('C'), Note.new('E'), Note.new('G#')]
    end
  end

  describe '#name' do
    it 'returns the correct name for a major chord' do
      chord = Chord.new(Note.new('C'), ChordShape.new('Major'))
      expect(chord.name).to eq 'C'
    end

    it 'returns the correct name for a minor chord' do
      chord = Chord.new(Note.new('A'), ChordShape.new('Minor'))
      expect(chord.name).to eq 'Am'
    end
  end

  describe '#quality' do
    it 'returns the correct quality for a major chord' do
      chord = Chord.new(Note.new('C'), ChordShape.new('Major'))
      expect(chord.quality).to eq 'Major'
    end

    it 'returns the correct quality for a minor chord' do
      chord = Chord.new(Note.new('A'), ChordShape.new('Minor'))
      expect(chord.quality).to eq 'Minor'
    end
  end

  describe '#display_joined_notes' do
    it 'returns notes joined by a -' do
      chord = Chord.new(Note.new('C'), ChordShape.new('Major'))
      expect(chord.display_joined_notes).to eq 'C - E - G'
    end

    describe 'when there are no notes' do
      it 'returns an empty string' do
        chord = Chord.new(Note.new('C'), ChordShape.new('Major'))
        chord.instance_variable_set(:@notes, [])
        expect(chord.display_joined_notes).to eq ''
      end
    end
  end

  describe '.from_json' do
    it 'creates a chord from a json string' do
      json = {
        'root' => { 'name' => 'C' },
        'chord_shape' => { 'quality' => 'Major' },
        'notes' => [
          { 'name' => 'C' }, { 'name' => 'E' }, { 'name' => 'G' }
        ],
        'name' => 'C'
      }

      chord = Chord.from_json(json)

      expect(chord).to eq(Chord.new(Note.new('C'), ChordShape.new('Major')))
    end
  end
end
