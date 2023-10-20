class Progression
  def initialize(chords)
    @progression = chords
  end

  def chords
    @progression
  end

  def add_chord(chord, mode)
    @progression << { 'chord' => chord, 'mode' => mode }
  end

  def add_silence
    @progression << { 'chord' => 'Silence', 'mode' => 'Silence' }
  end
end
