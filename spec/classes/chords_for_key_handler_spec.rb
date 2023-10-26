require 'rails_helper'

describe 'ChordsForKeyHandler' do
  describe '#chord_groups' do
    it 'returns a list of chords' do
      suggestor = ChordsForKeyHandler.new('C')
      chord_suggestions = suggestor.chord_groups

      chord_suggestions.each_pair do |mode, chord_groups|
        expect(Mode::ALL).to include(mode)

        mode = Object.const_get(mode.capitalize).new

        scale = Scale.new(Note.new('C'), mode)

        chord_groups.each do |chord_group|
          expect(scale.chord_groups.map(&:primary_chord)).to include(chord_group.primary_chord)
        end
      end
    end
  end
end
