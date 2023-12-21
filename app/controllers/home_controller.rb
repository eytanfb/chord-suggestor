class HomeController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:update]
  before_action :set_keys

  def index
    @key = params[:key]
    order_by = params[:order_by] || 'mode'

    return if @key.nil?

    @is_seventh = Rails.cache.fetch('is_seventh') { false }
    chords = ChordsForKeyHandler.new(@key, is_seventh: @is_seventh).chord_groups

    @chords = ChordsPresenter.new(chords).present(order_by: order_by.to_sym)
    # progression = JSON.parse(Rails.cache.fetch('progression') { [] })['progression']
    # @progression = Progression.new
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
