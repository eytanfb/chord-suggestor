require 'rails_helper'

describe 'ChordSuggestionHandler' do
  describe '#suggest_chords' do
    it 'returns a list of chords' do
      suggestor = ChordSuggestionHandler.new('C')
      chord_suggestions = suggestor.suggest_chords

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
