class ProgressionController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:update]

  def update
    current_progression = JSON.parse(params[:progression]) || []
    current_progression = [] if current_progression[0] == ''

    progression = Progression.from_json(current_progression)

    mode = params[:mode]
    if params[:chord_group] == 'Silence'
      progression.add_silence
    else
      unless params[:chord_group].blank? && mode.blank?
        chord_group = ChordGroup.from_json(JSON.parse(params[:chord_group]))
        progression.add_chord_group(chord_group, mode) unless chord_group.blank? && mode.blank?
      end
    end

    Rails.cache.write('progression', progression.to_json)

    render partial: 'shared/progression', locals: { progression: }
  end
end
