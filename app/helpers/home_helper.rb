module HomeHelper
  def note_asset_name(note)
    "#{note.gsub('#', '_sharp').gsub('b', '_flat')}.wav"
  end
end
