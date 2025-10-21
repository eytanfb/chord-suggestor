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
          allow(Rails.cache).to receive(:fetch).with('is_seventh', expires_in: 1.hour).and_return(false)
          allow(Rails.cache).to receive(:fetch).with('perspective', expires_in: 1.hour).and_return('primary')

          get :index, params: { key: 'C' }

          expect(assigns(:is_seventh)).to eq(false)
        end
      end

      describe 'when cache has is_seventh as true' do
        it 'assigns @is_seventh to true' do
          allow(Rails.cache).to receive(:fetch).with('is_seventh', expires_in: 1.hour).and_return(true)
          allow(Rails.cache).to receive(:fetch).with('perspective', expires_in: 1.hour).and_return('primary')

          get :index, params: { key: 'C' }

          expect(assigns(:is_seventh)).to eq(true)
        end
      end
    end

    describe '@chords' do
      it 'assigns @chords with chord groups' do
        get :index, params: { key: 'C' }

        # Check that chords are assigned and structured correctly
        expect(assigns(:chords)).to be_an(Array)
        expect(assigns(:chords).first).to be_an(Array)
        expect(assigns(:chords).first.first).to be_a(String) # Mode name
        expect(assigns(:chords).first.last).to be_an(Array)
        expect(assigns(:chords).first.last.first).to be_a(ChordGroup)
      end
    end
  end

  describe '@perspective' do
    describe 'when cache is empty' do
      it 'assigns @perspective to primary' do
        get :index, params: { key: 'C' }

        expect(assigns(:perspective)).to eq('primary')
      end
    end

    describe 'when cache has perspective as secondary_dominants' do
      it 'assigns @perspective to secondary_dominants' do
        allow(Rails.cache).to receive(:fetch).with('perspective', expires_in: 1.hour).and_return('secondary_dominants')
        allow(Rails.cache).to receive(:fetch).with('is_seventh', expires_in: 1.hour).and_return(false)
        allow(Rails.cache).to receive(:fetch).with('order_by', expires_in: 1.hour).and_return('mode')

        get :index, params: { key: 'C' }

        expect(assigns(:perspective)).to eq('secondary_dominants')
      end
    end
  end

  describe '@order_by' do
    describe 'when cache is empty and no param provided' do
      it 'assigns @order_by to mode' do
        get :index, params: { key: 'C' }

        expect(assigns(:order_by)).to eq('mode')
      end
    end

    describe 'when order_by param is provided' do
      it 'assigns @order_by to degree' do
        get :index, params: { key: 'C', order_by: 'degree' }

        expect(assigns(:order_by)).to eq('degree')
      end
    end

    describe 'when cache has order_by as degree' do
      it 'assigns @order_by to degree' do
        allow(Rails.cache).to receive(:fetch).with('order_by', expires_in: 1.hour).and_return('degree')
        allow(Rails.cache).to receive(:fetch).with('perspective', expires_in: 1.hour).and_return('primary')
        allow(Rails.cache).to receive(:fetch).with('is_seventh', expires_in: 1.hour).and_return(false)

        get :index, params: { key: 'C' }

        expect(assigns(:order_by)).to eq('degree')
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

    it 'updates the cache with perspective' do
      post :update, params: { perspective: 'secondary_dominants', key: 'C' }

      expect(Rails.cache.fetch('perspective')).to eq('secondary_dominants')
    end

    it 'updates the cache with diminished_approaches perspective' do
      post :update, params: { perspective: 'diminished_approaches', key: 'C' }

      expect(Rails.cache.fetch('perspective')).to eq('diminished_approaches')
    end

    it 'updates the cache with order_by' do
      post :update, params: { order_by: 'degree', key: 'C' }, format: :turbo_stream

      expect(Rails.cache.fetch('order_by')).to eq('degree')
    end

    it 'returns turbo stream response for order_by update' do
      post :update, params: { order_by: 'degree', key: 'C' }, format: :turbo_stream

      expect(response.content_type).to include('text/vnd.turbo-stream.html')
      expect(response).to have_http_status(:success)
    end
  end
end
