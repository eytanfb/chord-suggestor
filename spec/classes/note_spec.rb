require 'rails_helper'

describe 'Note' do
  describe '#initialize' do
    it 'creates a new note with the correct name and semitones' do
      note = Note.new('C')
      expect(note.name).to eq('C')
      expect(note.semitones).to eq(0)
    end
  end

  describe '#up' do
    it 'returns a new note that is the given interval higher' do
      note = Note.new('D')
      expect(note.up(1).name).to eq('D#')
      expect(note.up(2).name).to eq('E')
      expect(note.up(12).name).to eq('D')
    end
  end

  describe '#down' do
    it 'returns a new note that is the given interval lower' do
      note = Note.new('C')
      expect(note.down(1).name).to eq('B')
      expect(note.down(2).name).to eq('A#')
      expect(note.down(12).name).to eq('C')
    end
  end

  describe '.flat_version' do
    it 'returns the same note if it already has a flat or is F or C' do
      note = Note.new('F')
      expect(Note.flat_version(note).name).to eq('F')
      note = Note.new('C')
      expect(Note.flat_version(note).name).to eq('C')
      note = Note.new('Bb')
      expect(Note.flat_version(note).name).to eq('Bb')
      note = Note.new('Eb')
      expect(Note.flat_version(note).name).to eq('Eb')
    end

    it 'returns the same note if not does not have sharp' do
      note = Note.new('A')
      expect(Note.flat_version(note).name).to eq('A')
      note = Note.new('D')
      expect(Note.flat_version(note).name).to eq('D')
      note = Note.new('G')
      expect(Note.flat_version(note).name).to eq('G')
    end

    it 'returns the flat version of a note' do
      note = Note.new('C#')
      expect(Note.flat_version(note).name).to eq('Db')
      note = Note.new('F#')
      expect(Note.flat_version(note).name).to eq('Gb')
      note = Note.new('G#')
      expect(Note.flat_version(note).name).to eq('Ab')
      note = Note.new('A#')
      expect(Note.flat_version(note).name).to eq('Bb')
    end
  end

  describe '.sharp_version' do
    it 'returns the same note if it already has a sharp or is E or B' do
      note = Note.new('E')
      expect(Note.sharp_version(note).name).to eq('E')
      note = Note.new('B')
      expect(Note.sharp_version(note).name).to eq('B')
      note = Note.new('C#')
      expect(Note.sharp_version(note).name).to eq('C#')
      note = Note.new('G#')
      expect(Note.sharp_version(note).name).to eq('G#')
    end

    it 'returns the same note if not does not have flat' do
      note = Note.new('A')
      expect(Note.sharp_version(note).name).to eq('A')
      note = Note.new('D')
      expect(Note.sharp_version(note).name).to eq('D')
      note = Note.new('G')
      expect(Note.sharp_version(note).name).to eq('G')
    end

    it 'returns the sharp version of a note' do
      note = Note.new('Db')
      expect(Note.sharp_version(note).name).to eq('C#')
      note = Note.new('Gb')
      expect(Note.sharp_version(note).name).to eq('F#')
      note = Note.new('Ab')
      expect(Note.sharp_version(note).name).to eq('G#')
      note = Note.new('Bb')
      expect(Note.sharp_version(note).name).to eq('A#')
    end
  end

  describe '#flat?' do
    it 'returns true if the note is flat' do
      note = Note.new('Db')
      expect(note.flat?).to be true
      note = Note.new('Gb')
      expect(note.flat?).to be true
      note = Note.new('Ab')
      expect(note.flat?).to be true
      note = Note.new('Bb')
      expect(note.flat?).to be true
    end

    it 'returns false if the note is not flat' do
      note = Note.new('C')
      expect(note.flat?).to be false
      note = Note.new('D')
      expect(note.flat?).to be false
      note = Note.new('E')
      expect(note.flat?).to be false
      note = Note.new('F')
      expect(note.flat?).to be false
      note = Note.new('G')
      expect(note.flat?).to be false
      note = Note.new('A')
      expect(note.flat?).to be false
      note = Note.new('B')
      expect(note.flat?).to be false
    end
  end

  describe '#sharp?' do
    it 'returns true if the note is sharp' do
      note = Note.new('C#')
      expect(note.sharp?).to be true
      note = Note.new('F#')
      expect(note.sharp?).to be true
      note = Note.new('G#')
      expect(note.sharp?).to be true
      note = Note.new('A#')
      expect(note.sharp?).to be true
    end

    it 'returns false if the note is not sharp' do
      note = Note.new('C')
      expect(note.sharp?).to be false
      note = Note.new('D')
      expect(note.sharp?).to be false
      note = Note.new('E')
      expect(note.sharp?).to be false
      note = Note.new('F')
      expect(note.sharp?).to be false
      note = Note.new('G')
      expect(note.sharp?).to be false
      note = Note.new('A')
      expect(note.sharp?).to be false
      note = Note.new('B')
      expect(note.sharp?).to be false
    end
  end

  describe '#flatten_without_interval' do
    it 'returns a new note that is flattened without changing the interval' do
      note = Note.new('F')
      expect(note.flatten_without_interval.name).to eq('Fb')
      note = Note.new('B')
      expect(note.flatten_without_interval.name).to eq('Bb')
    end
  end

  describe '#sharpen_without_interval' do
    it 'returns a new note that is sharpened without changing the interval' do
      note = Note.new('E')
      expect(note.sharpen_without_interval.name).to eq('E#')
      note = Note.new('B')
      expect(note.sharpen_without_interval.name).to eq('B#')
    end
  end

  describe '#successive_to?' do
    it 'returns true if the note is successive to the given note' do
      note = Note.new('C')
      expect(note.successive_to?(Note.new('B'))).to be true
      note = Note.new('D')
      expect(note.successive_to?(Note.new('C'))).to be true
      note = Note.new('E')
      expect(note.successive_to?(Note.new('D'))).to be true
      note = Note.new('F')
      expect(note.successive_to?(Note.new('E'))).to be true
      note = Note.new('G')
      expect(note.successive_to?(Note.new('F'))).to be true
      note = Note.new('A')
      expect(note.successive_to?(Note.new('G'))).to be true
      note = Note.new('B')
      expect(note.successive_to?(Note.new('A'))).to be true
    end

    it 'returns false if the note is not successive to the given note' do
      note = Note.new('C')
      expect(note.successive_to?(Note.new('C'))).to be false
      note = Note.new('D')
      expect(note.successive_to?(Note.new('D'))).to be false
      note = Note.new('E')
      expect(note.successive_to?(Note.new('E'))).to be false
      note = Note.new('F')
      expect(note.successive_to?(Note.new('F'))).to be false
      note = Note.new('G')
      expect(note.successive_to?(Note.new('G'))).to be false
      note = Note.new('A')
      expect(note.successive_to?(Note.new('A'))).to be false
      note = Note.new('B')
      expect(note.successive_to?(Note.new('B'))).to be false
      note = Note.new('C')
      expect(note.successive_to?(Note.new('A#'))).to be false
    end
  end

  describe '#==' do
    it 'returns true if the notes are the same' do
      note = Note.new('C')
      expect(note == Note.new('C')).to be true
      note = Note.new('C#')
      expect(note == Note.new('C#')).to be true
      note = Note.new('Db')
      expect(note == Note.new('Db')).to be true
    end

    it 'returns false if the notes are not the same' do
      note = Note.new('C')
      expect(note == Note.new('D')).to be false
      note = Note.new('C#')
      expect(note == Note.new('D')).to be false
      note = Note.new('Db')
      expect(note == Note.new('D')).to be false
    end
  end
end
