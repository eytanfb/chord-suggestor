class ProgressionController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:update]

  def update
    current_progression = JSON.parse(params[:progression]) || []

    progression = Progression.new(current_progression)

    chord = params[:chord]
    mode = params[:mode]

    progression.add_chord(chord, mode)

    render partial: 'shared/progression', locals: { progression: }
  end
end
