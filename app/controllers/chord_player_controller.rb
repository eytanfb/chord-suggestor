class ChordPlayerController < ApplicationController
  def play
    chord = ChordGenerator.from_string(params[:chord])

    respond_to do |format|
      format.js { render inline: ChordPlayerService.new(chord).play }
    end
  end
end
