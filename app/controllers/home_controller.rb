class HomeController < ApplicationController
  def index
    @keys = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B']
    @key = params[:key]

    return if @key.nil?

    chords = ChordSuggestionHandler.new(@key).suggest_chords

    @chords = ChordsPresenter.new(chords).present
  end
end
