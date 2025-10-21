require 'rails_helper'

describe ChordsPresenter do
  let(:c_major) { Chord.new(Note.new('C'), ChordShape.new('Major')) }
  let(:d_minor) { Chord.new(Note.new('D'), ChordShape.new('Minor')) }
  let(:a_dominant) { Chord.new(Note.new('A'), ChordShape.new('Dominant 7')) }
  let(:c_sharp_diminished) { Chord.new(Note.new('C#'), ChordShape.new('Diminished 7')) }

  describe '#present' do
    context 'with primary perspective' do
      it 'returns chords ordered by mode' do
        chord_groups = [
          ChordGroup.new(c_major),
          ChordGroup.new(d_minor)
        ]

        chords = { 'Ionian' => chord_groups }
        presenter = ChordsPresenter.new(chords)

        result = presenter.present(order_by: :mode, perspective: :primary)

        expect(result).to eq([['Ionian', chord_groups]])
      end
    end

    context 'with secondary_dominants perspective' do
      it 'replaces chords with secondary dominants when available' do
        # Create chord groups with alternatives
        chord_group_i = ChordGroup.new(c_major)

        chord_group_ii = ChordGroup.new(d_minor)
        chord_group_ii.add_alternative(a_dominant)
        chord_group_ii.add_alternative(c_sharp_diminished)

        chord_groups = [chord_group_i, chord_group_ii]
        chords = { 'Ionian' => chord_groups }
        presenter = ChordsPresenter.new(chords)

        result = presenter.present(order_by: :mode, perspective: :secondary_dominants)

        # Index 0 (I) should keep primary chord
        expect(result[0][1][0].primary_chord).to eq(c_major)

        # Index 1 (ii) should have secondary dominant (first alternative)
        expect(result[0][1][1].primary_chord).to eq(a_dominant)
      end

      it 'keeps primary chord when no alternatives exist' do
        chord_group = ChordGroup.new(c_major)

        chords = { 'Ionian' => [chord_group] }
        presenter = ChordsPresenter.new(chords)

        result = presenter.present(order_by: :mode, perspective: :secondary_dominants)

        expect(result[0][1][0].primary_chord).to eq(c_major)
      end
    end

    context 'with diminished_approaches perspective' do
      it 'replaces chords with diminished approaches when available' do
        # Create chord groups with alternatives
        chord_group_i = ChordGroup.new(c_major)

        chord_group_ii = ChordGroup.new(d_minor)
        chord_group_ii.add_alternative(a_dominant)
        chord_group_ii.add_alternative(c_sharp_diminished)

        chord_groups = [chord_group_i, chord_group_ii]
        chords = { 'Ionian' => chord_groups }
        presenter = ChordsPresenter.new(chords)

        result = presenter.present(order_by: :mode, perspective: :diminished_approaches)

        # Index 0 (I) should keep primary chord
        expect(result[0][1][0].primary_chord).to eq(c_major)

        # Index 1 (ii) should have diminished approach (second alternative)
        expect(result[0][1][1].primary_chord).to eq(c_sharp_diminished)
      end

      it 'keeps primary chord when no second alternative exists' do
        chord_group = ChordGroup.new(c_major)
        chord_group.add_alternative(a_dominant)

        chords = { 'Ionian' => [chord_group] }
        presenter = ChordsPresenter.new(chords)

        result = presenter.present(order_by: :mode, perspective: :diminished_approaches)

        expect(result[0][1][0].primary_chord).to eq(c_major)
      end
    end

    context 'with order_by degree' do
      it 'orders chords by degree when requested' do
        chords = {
          'Ionian' => [ChordGroup.new(c_major)],
          'Dorian' => [ChordGroup.new(d_minor)]
        }
        presenter = ChordsPresenter.new(chords)

        result = presenter.present(order_by: :degree, perspective: :primary)

        expect(result.map(&:first)).to eq(['Ionian', 'Dorian'])
      end
    end

    context 'with invalid order_by' do
      it 'raises an ArgumentError' do
        chords = { 'Ionian' => [ChordGroup.new(c_major)] }
        presenter = ChordsPresenter.new(chords)

        expect {
          presenter.present(order_by: :invalid, perspective: :primary)
        }.to raise_error(ArgumentError, /Unknown order_by/)
      end
    end
  end
end
