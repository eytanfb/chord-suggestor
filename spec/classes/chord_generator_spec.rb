require 'rails_helper'

describe 'ChordGenerator' do
  describe '.from_string' do
    context 'when given a valid chord string' do
      let(:chord_string) { 'Cm' }
      let(:note) { Note.new('C') }
      let(:chord_shape) { ChordShape.new('Minor') }

      it 'returns a Chord object' do
        expect(ChordGenerator.from_string(chord_string)).to be_a(Chord)
      end

      it 'returns a Chord object with the correct note and chord shape' do
        expect(ChordGenerator.from_string(chord_string).notes.first.name).to eq(note.name)
        expect(ChordGenerator.from_string(chord_string).quality).to eq(chord_shape.quality)
      end
    end
  end

  describe '.shape_from_string' do
    context 'when given a valid chord string' do
      let(:chord_string) { 'Cm' }

      it 'returns the chord shape' do
        expect(ChordGenerator.shape_from_string(chord_string).quality).to eq('Minor')
      end
    end
  end

  describe '.note_from_string' do
    context 'when given a valid chord string' do
      let(:chord_string) { 'Cm' }

      it 'returns the note' do
        expect(ChordGenerator.note_from_string(chord_string).name).to eq('C')
      end
    end
  end
end
