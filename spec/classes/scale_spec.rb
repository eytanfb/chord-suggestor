require 'rails_helper'

describe 'Scale' do
  describe '#initialize' do
    describe 'given an aeolian mode' do
      it 'creates an aeolian scale starting on A' do
        scale = Scale.new(Note.new('A'), Aeolian.new)
        expect(scale.notes.map(&:name)).to eq(%w[A B C D E F G])
      end

      it 'creates an aeolian scale starting on B' do
        scale = Scale.new(Note.new('B'), Aeolian.new)

        expect(scale.notes.map(&:name)).to eq(%w[B C# D E F# G A])
      end

      it 'creates an aeolian scale starting on C' do
        scale = Scale.new(Note.new('C'), Aeolian.new)

        expect(scale.notes.map(&:name)).to eq(%w[C D Eb F G Ab Bb])
      end

      it 'creates an aeolian scale starting on D' do
        scale = Scale.new(Note.new('D'), Aeolian.new)

        expect(scale.notes.map(&:name)).to eq(%w[D E F G A Bb C])
      end

      it 'creates an aeolian scale starting on E' do
        scale = Scale.new(Note.new('E'), Aeolian.new)

        expect(scale.notes.map(&:name)).to eq(%w[E F# G A B C D])
      end

      it 'creates an aeolian scale starting on F' do
        scale = Scale.new(Note.new('F'), Aeolian.new)

        expect(scale.notes.map(&:name)).to eq(%w[F G Ab Bb C Db Eb])
      end

      it 'creates an aeolian scale starting on G' do
        scale = Scale.new(Note.new('G'), Aeolian.new)

        expect(scale.notes.map(&:name)).to eq(%w[G A Bb C D Eb F])
      end

      it 'creates an aeolian scale starting on A#' do
        scale = Scale.new(Note.new('A#'), Aeolian.new)

        expect(scale.notes.map(&:name)).to eq(%w[A# B# C# D# E# F# G#])
      end

      it 'creates an aeolian scale starting on Bb' do
        scale = Scale.new(Note.new('Bb'), Aeolian.new)

        expect(scale.notes.map(&:name)).to eq(%w[Bb C Db Eb F Gb Ab])
      end

      it 'creates an aeolian scale starting on C#' do
        scale = Scale.new(Note.new('C#'), Aeolian.new)

        expect(scale.notes.map(&:name)).to eq(%w[C# D# E F# G# A B])
      end

      it 'creates an aeolian scale starting on Db' do
        scale = Scale.new(Note.new('Db'), Aeolian.new)

        expect(scale.notes.map(&:name)).to eq(%w[Db Eb Fb Gb Ab Bbb Cb])
      end

      it 'creates an aeolian scale starting on D#' do
        scale = Scale.new(Note.new('D#'), Aeolian.new)

        expect(scale.notes.map(&:name)).to eq(%w[D# E# F# G# A# B C#])
      end

      it 'creates an aeolian scale starting on Eb' do
        scale = Scale.new(Note.new('Eb'), Aeolian.new)

        expect(scale.notes.map(&:name)).to eq(%w[Eb F Gb Ab Bb Cb Db])
      end

      it 'creates an aeolian scale starting on F#' do
        scale = Scale.new(Note.new('F#'), Aeolian.new)

        expect(scale.notes.map(&:name)).to eq(%w[F# G# A B C# D E])
      end

      it 'creates an aeolian scale starting on Gb' do
        scale = Scale.new(Note.new('Gb'), Aeolian.new)

        expect(scale.notes.map(&:name)).to eq(%w[Gb Ab Bbb Cb Db Ebb Fb])
      end

      it 'creates an aeolian scale starting on G#' do
        scale = Scale.new(Note.new('G#'), Aeolian.new)

        expect(scale.notes.map(&:name)).to eq(%w[G# A# B C# D# E F#])
      end
    end

    describe 'given a dorian mode' do
      it 'creates a dorian scale starting on A' do
        scale = Scale.new(Note.new('A'), Dorian.new)

        expect(scale.notes.map(&:name)).to eq(%w[A B C D E F# G])
      end

      it 'creates a dorian scale starting on B' do
        scale = Scale.new(Note.new('B'), Dorian.new)

        expect(scale.notes.map(&:name)).to eq(%w[B C# D E F# G# A])
      end

      it 'creates a dorian scale starting on C' do
        scale = Scale.new(Note.new('C'), Dorian.new)

        expect(scale.notes.map(&:name)).to eq(%w[C D Eb F G A Bb])
      end

      it 'creates a dorian scale starting on D' do
        scale = Scale.new(Note.new('D'), Dorian.new)

        expect(scale.notes.map(&:name)).to eq(%w[D E F G A B C])
      end

      it 'creates a dorian scale starting on E' do
        scale = Scale.new(Note.new('E'), Dorian.new)

        expect(scale.notes.map(&:name)).to eq(%w[E F# G A B C# D])
      end

      it 'creates a dorian scale starting on F' do
        scale = Scale.new(Note.new('F'), Dorian.new)

        expect(scale.notes.map(&:name)).to eq(%w[F G Ab Bb C D Eb])
      end

      it 'creates a dorian scale starting on G' do
        scale = Scale.new(Note.new('G'), Dorian.new)

        expect(scale.notes.map(&:name)).to eq(%w[G A Bb C D E F])
      end

      it 'creates a dorian scale starting on A#' do
        scale = Scale.new(Note.new('A#'), Dorian.new)

        expect(scale.notes.map(&:name)).to eq(%w[A# B# C# D# E# F## G#])
      end

      it 'creates a dorian scale starting on Bb' do
        scale = Scale.new(Note.new('Bb'), Dorian.new)

        expect(scale.notes.map(&:name)).to eq(%w[Bb C Db Eb F G Ab])
      end

      it 'creates a dorian scale starting on C#' do
        scale = Scale.new(Note.new('C#'), Dorian.new)

        expect(scale.notes.map(&:name)).to eq(%w[C# D# E F# G# A# B])
      end

      it 'creates a dorian scale starting on Db' do
        scale = Scale.new(Note.new('Db'), Dorian.new)

        expect(scale.notes.map(&:name)).to eq(%w[Db Eb Fb Gb Ab Bb Cb])
      end

      it 'creates a dorian scale starting on D#' do
        scale = Scale.new(Note.new('D#'), Dorian.new)

        expect(scale.notes.map(&:name)).to eq(%w[D# E# F# G# A# B# C#])
      end

      it 'creates a dorian scale starting on Eb' do
        scale = Scale.new(Note.new('Eb'), Dorian.new)

        expect(scale.notes.map(&:name)).to eq(%w[Eb F Gb Ab Bb C Db])
      end

      it 'creates a dorian scale starting on F#' do
        scale = Scale.new(Note.new('F#'), Dorian.new)

        expect(scale.notes.map(&:name)).to eq(%w[F# G# A B C# D# E])
      end

      it 'creates a dorian scale starting on Gb' do
        scale = Scale.new(Note.new('Gb'), Dorian.new)

        expect(scale.notes.map(&:name)).to eq(%w[Gb Ab Bbb Cb Db Eb Fb])
      end

      it 'creates a dorian scale starting on G#' do
        scale = Scale.new(Note.new('G#'), Dorian.new)

        expect(scale.notes.map(&:name)).to eq(%w[G# A# B C# D# E# F#])
      end
    end
  end

  describe '#chords' do
    describe 'given an aeolian scale' do
      it 'returns an array of chords' do
        scale = Scale.new(Note.new('A'), Aeolian.new)

        expect(scale.chords.map(&:name)).to eq(
          %w[
            Am
            B°
            C
            Dm
            Em
            F
            G
          ]
        )
      end
    end

    describe 'given a dorian scale' do
      it 'returns an array of chords' do
        scale = Scale.new(Note.new('A'), Dorian.new)

        expect(scale.chords.map(&:name)).to eq(
          [
            'Am',
            'Bm',
            'C',
            'D',
            'Em',
            'F#°',
            'G'
          ]
        )
      end
    end
  end
end
