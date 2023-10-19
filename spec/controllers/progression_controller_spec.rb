require 'rails_helper'

describe 'ProgressionController', type: :controller do
  render_views

  before(:each) do
    @controller = ProgressionController.new
  end

  describe '#update' do
    let(:progression) { Progression.new([]) }
    let(:chord) { 'C' }
    let(:mode) { 'major' }
    let(:params) { { progression: progression.to_json, chord:, mode: } }

    before do
      allow(Progression).to receive(:new).and_return(progression)
    end

    it 'adds a chord to the progression' do
      expect(progression).to receive(:add_chord).with(chord, mode)
      post :update, params:
    end

    it 'renders the progression partial' do
      post(:update, params:)
      expect(response).to render_template(partial: 'shared/_progression')
    end
  end
end
