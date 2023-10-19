class ProgressionController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:update]

  def update
    # get the current progression as params
    # add the new chord and mode
    # return the updated progression
    # render json: { progression: progression }
    current_progression = JSON.parse(params[:progression]) || []

    p current_progression

    progression = Progression.new(current_progression)

    chord = params[:chord]
    mode = params[:mode]

    progression.add_chord(chord, mode)

    p progression.chords

    render partial: 'shared/progression', locals: { progression: }
  end
end
