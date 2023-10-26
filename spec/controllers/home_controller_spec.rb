require 'rails_helper'

describe 'HomeController', type: :controller do
  render_views

  before(:each) do
    @controller = HomeController.new
  end

  describe '#index' do
    it 'returns a list of chords for a given key' do
      get :index, params: { key: 'C' }

      expect(response).to have_http_status(:success)
    end

    it 'assigns @keys' do
      get :index

      expect(assigns(:keys)).to eq([
                                     Note.new('C'),
                                     Note.new('C#'),
                                     Note.new('D'),
                                     Note.new('D#'),
                                     Note.new('E'),
                                     Note.new('F'),
                                     Note.new('F#'),
                                     Note.new('G'),
                                     Note.new('G#'),
                                     Note.new('A'),
                                     Note.new('A#'),
                                     Note.new('B')
                                   ])
    end

    it 'assigns @key' do
      get :index, params: { key: 'C' }

      expect(assigns(:key)).to eq('C')
    end

    describe '@is_seventh' do
      describe 'when cache is empty' do
        it 'assigns @is_seventh to false' do
          get :index, params: { key: 'C' }

          expect(assigns(:is_seventh)).to eq(false)
        end
      end

      describe 'when cache has is_seventh as false' do
        it 'assigns @is_seventh to false' do
          allow(Rails.cache).to receive(:fetch).with('is_seventh').and_return(false)

          get :index, params: { key: 'C' }

          expect(assigns(:is_seventh)).to eq(false)
        end
      end

      describe 'when cache has is_seventh as true' do
        it 'assigns @is_seventh to true' do
          allow(Rails.cache).to receive(:fetch).with('is_seventh').and_return(true)

          get :index, params: { key: 'C' }

          expect(assigns(:is_seventh)).to eq(true)
        end
      end
    end

    describe '@chords' do
      it 'assigns @chords' do
        get :index, params: { key: 'C' }

        expect(assigns(:chords)).to include(
          ['Ionian',
           [
             ChordGroup.new(Chord.new(Note.new('C'), ChordShape.new('Major'))),
             ChordGroup.new(Chord.new(Note.new('D'), ChordShape.new('Minor'))),
             ChordGroup.new(Chord.new(Note.new('E'), ChordShape.new('Minor'))),
             ChordGroup.new(Chord.new(Note.new('F'), ChordShape.new('Major'))),
             ChordGroup.new(Chord.new(Note.new('G'), ChordShape.new('Major'))),
             ChordGroup.new(Chord.new(Note.new('A'), ChordShape.new('Minor'))),
             ChordGroup.new(Chord.new(Note.new('B'), ChordShape.new('Diminished')))
           ]]
        )
      end
    end
  end

  describe '#update' do
    let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) }
    let(:cache) { Rails.cache }

    before do
      allow(Rails).to receive(:cache).and_return(memory_store)
      Rails.cache.clear
    end

    it 'updates the cache with is_seventh' do
      post :update, params: { is_seventh: 'true' }

      expect(Rails.cache.fetch('is_seventh')).to eq(true)
    end
  end
end
