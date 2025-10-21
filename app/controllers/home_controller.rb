class HomeController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:update]
  before_action :set_keys

  def index
    @key = params[:key]
    @order_by = params[:order_by] || Rails.cache.fetch('order_by', expires_in: 1.hour) { 'mode' }

    return if @key.nil?

    # Cache the current key and order_by for later use
    Rails.cache.write('current_key', @key)
    Rails.cache.write('order_by', @order_by) if params[:order_by].present?

    @is_seventh = Rails.cache.fetch('is_seventh', expires_in: 1.hour) { false }
    @perspective = Rails.cache.fetch('perspective', expires_in: 1.hour) { 'primary' }
    chords = ChordsForKeyHandler.new(@key, is_seventh: @is_seventh).chord_groups

    @chords = ChordsPresenter.new(chords).present(order_by: @order_by.to_sym, perspective: @perspective.to_sym)
  end

  def update
    # Always fetch all settings from cache first
    is_seventh = Rails.cache.fetch('is_seventh', expires_in: 1.hour) { false }
    perspective = Rails.cache.fetch('perspective', expires_in: 1.hour) { 'primary' }
    order_by = Rails.cache.fetch('order_by', expires_in: 1.hour) { 'mode' }

    Rails.logger.info "[HomeController#update] Params: #{params.inspect}"
    Rails.logger.info "[HomeController#update] Cache before: is_seventh=#{is_seventh}, perspective=#{perspective}, order_by=#{order_by}"

    # Update is_seventh if provided
    if params[:is_seventh].present?
      is_seventh = params[:is_seventh] == 'true'
      Rails.cache.write('is_seventh', is_seventh, expires_in: 1.hour)
      Rails.logger.info "[HomeController#update] Updated is_seventh to #{is_seventh}"
    end

    # Update perspective if provided
    if params[:perspective].present?
      perspective = params[:perspective]
      Rails.cache.write('perspective', perspective, expires_in: 1.hour)
      Rails.logger.info "[HomeController#update] Updated perspective to #{perspective}"
    end

    # Update order_by if provided
    if params[:order_by].present?
      order_by = params[:order_by]
      Rails.cache.write('order_by', order_by, expires_in: 1.hour)
      Rails.logger.info "[HomeController#update] Updated order_by to #{order_by}"
    end

    @key = params[:key] || Rails.cache.fetch('current_key')
    @order_by = order_by

    Rails.logger.info "[HomeController#update] Final: key=#{@key}, is_seventh=#{is_seventh}, perspective=#{perspective}, order_by=#{order_by}"

    return head :ok if @key.nil?

    chords = ChordsForKeyHandler.new(@key, is_seventh: is_seventh).chord_groups
    @chords = ChordsPresenter.new(chords).present(order_by: @order_by.to_sym, perspective: perspective.to_sym)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          'chord-grid',
          partial: 'home/chord_grid',
          locals: { chords: @chords }
        )
      end
      format.html { head :ok }
    end
  end

  private

  def set_keys
    @keys = Note::ALL.map { |key| Note.new(key) }
  end
end
