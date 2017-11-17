require 'rails_helper'

describe SynchronizationsController do
  let!(:facility) { create(:facility) }

  describe 'new' do
    let(:synchronizer) { double(:synchronizer, success_message: 'success_message', error_message: 'error_message') }

    before do
      allow_any_instance_of(described_class).to receive(:synchronizer).and_return(synchronizer)
      allow(synchronizer).to                    receive(:synchronize_data)
      allow(synchronizer).to                    receive(:success?).and_return(true)
    end

    it 'runs synchronize_data of synchronizer' do
      expect(synchronizer).to receive(:synchronize_data)

      get :new, params: { facility_id: facility.id }
    end

    context 'when synchronization is success' do
      it 'redirects to facilities_path with notice' do
        get :new, params: { facility_id: facility.id }

        expect(response).to redirect_to(facilities_path)
        expect(flash[:notice]).to eq(synchronizer.success_message)
      end
    end

    context 'when synchronization is not success' do
      before { allow(synchronizer).to receive(:success?).and_return(false) }

      it 'redirects to facilities_path with error' do
        get :new, params: { facility_id: facility.id }

        expect(response).to redirect_to(facilities_path)
        expect(flash[:error]).to eq(synchronizer.error_message)
      end
    end
  end
end
