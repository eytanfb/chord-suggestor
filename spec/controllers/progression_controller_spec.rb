require 'rails_helper'

describe 'ProgressionController', type: :controller do
  render_views

  before(:each) do
    @controller = ProgressionController.new
  end

  describe '#update' do
    let(:progression) { Progression.new([]) }
    let(:chord_group) { ChordGroup.new(Chord.new(Note.new('C'), ChordShape.new('Major'))) }
    let(:mode) { 'Ionian' }
    let(:params) { { progression: progression.to_json, chord_group: chord_group.to_json, mode: } }

    before do
      allow(Progression).to receive(:new).and_return(progression)
    end

    it 'adds a chord to the progression' do
      expect(progression).to receive(:add_chord_group).with(chord_group, mode)
      post :update, params:
    end

    it 'renders the progression partial' do
      post(:update, params:)
      expect(response).to render_template(partial: 'shared/_progression')
    end

    it 'removes a chord from the progression' do
      expect(progression).to receive(:remove_chord_group).with(chord_group, mode)
      post :update, params:
    end
  end
end
