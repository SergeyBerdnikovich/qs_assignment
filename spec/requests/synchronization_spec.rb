require 'rails_helper'

describe 'Synchronization', :vcr do
  let!(:facility) { create(:facility) }

  context 'when synchronization is run first time' do
    it 'redirects to facilities page without error' do
      get "/facilities/#{facility.id}/synchronizations/new"

      expect(response).to redirect_to(facilities_path)
      expect(flash[:error]).to be nil
    end
  end

  context 'when synchronization is run second time' do
    before { get "/facilities/#{facility.id}/synchronizations/new" }

    it 'redirects to facilities page without error' do
      get "/facilities/#{facility.id}/synchronizations/new"

      expect(response).to redirect_to(facilities_path)
      expect(flash[:error]).to be nil
    end
  end

  context 'when synchronization is failed' do
    let!(:facility) { create(:facility, user: 'incorrect user name') }

    it 'redirects to facilities page with error' do
      get "/facilities/#{facility.id}/synchronizations/new"

      expect(response).to redirect_to(facilities_path)
      expect(flash[:error]).to_not be nil
    end
  end
end
