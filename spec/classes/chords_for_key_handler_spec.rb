require 'rails_helper'

describe 'ChordsForKeyHandler' do
  describe '#chords' do
    it 'returns a list of chords' do
      suggestor = ChordsForKeyHandler.new('C')
      chord_suggestions = suggestor.chords

      chord_suggestions.each_pair do |mode, chords|
        expect(Mode::ALL).to include(mode)

        mode = Object.const_get(mode.capitalize).new

        scale = Scale.new(Note.new('C'), mode)

        chords.each do |chord|
          expect(scale.chords).to include(chord)
        end
      end
    end
  end
end
