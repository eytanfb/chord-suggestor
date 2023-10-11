class HomeController < ApplicationController
  def index
    # define an array of musical keys
    #
    @keys = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B']
    @modes_and_chords = [
      {
        mode: 'Lydian',
        chords: ['Major', 'Major', 'Minor', 'Sharp Minor Diminished', 'Major', 'Minor', 'Minor']
      },
      {
        mode: 'Ionian',
        chords: %w[Major Minor Minor Major Major Minor Diminished]
      },
      {
        mode: 'Mixolydian',
        chords: ['Major', 'Minor', 'Minor Diminished', 'Major', 'Minor', 'Minor', 'Flat Major']
      },
      {
        mode: 'Dorian',
        chords: ['Minor', 'Minor', 'Flat Major', 'Major', 'Minor', 'Diminished', 'Flat Major']
      },
      {
        mode: 'Aeolian',
        chords: %w[Minor Diminished Major Minor Minor Major Major]
      }
      # {
      # mode: 'Phrygian',
      # chords: ['Minor', 'Flat Major', 'Flat Major', 'Minor', 'Diminished', 'Flat Major', 'Flat Minor']
      # },
      # {
      # mode: 'Locrian',
      # chords: ['Diminished', 'Flat Major', 'Flat Minor', 'Minor', 'Flat Major', 'Flat Major', 'Flat Minor']
      # }
    ]
  end
end
