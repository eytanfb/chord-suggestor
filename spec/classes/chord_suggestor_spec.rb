require 'rails_helper'

describe 'ChordSuggestionHandler' do
  describe '#suggest_chords' do
    it 'returns a list of chords' do
      suggestor = ChordSuggestionHandler.new('C')
      expect(suggestor.suggest_chords).to eq(
        {
          'Ionian' => %w[
            C
            Dm
            Em
            F
            G
            Am
            Bdim
          ],
          'Dorian' => %w[
            Cm
            Dm
            Eb
            F
            G
            Am
            Bb
          ]
        }
      )
    end
  end
end
