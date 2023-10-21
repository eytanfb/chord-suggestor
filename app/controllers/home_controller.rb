class HomeController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:update]
  before_action :set_keys

  def index
    @key = params[:key]

    return if @key.nil?

    @is_seventh = Rails.cache.fetch('is_seventh') { false }
    chords = ChordSuggestionHandler.new(@key, is_seventh: @is_seventh).suggest_chords

    @chords = ChordsPresenter.new(chords).present
    progression = JSON.parse(Rails.cache.fetch('progression') { [] })['progression']
    @progression = Progression.new(progression)
  end

  def update
    is_seventh = params[:is_seventh] == 'true'

    Rails.cache.write('is_seventh', is_seventh)
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
