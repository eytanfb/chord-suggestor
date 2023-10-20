class HomeController < ApplicationController
  before_action :set_keys

  def index
    @key = params[:key]

    return if @key.nil?

    chords = ChordSuggestionHandler.new(@key).suggest_chords

    @chords = ChordsPresenter.new(chords).present
  end

  private

  def set_keys
    # create a an array of notes for all keys
    keys = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B']

    @keys = keys.map do |key|
      Note.new(key)
    end
  end
end
