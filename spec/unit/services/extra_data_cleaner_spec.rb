require 'rails_helper'

describe ExtraDataCleaner do
  subject { described_class.new(entity_name, ids) }

  let(:entity_name) { :facility }
  let!(:facility1)  { create(:facility) }
  let!(:facility2)  { create(:facility) }
  let!(:facility3)  { create(:facility) }

  context 'when there is only 1 id' do
    let(:ids) { facility1.id }

    it 'removes all extra entity from db' do
      subject.clean_extra_data

      expect(facility1.class.all).to eq([facility1])
    end
  end

  context 'when there is few ids' do
    let(:ids) { [facility1.id, facility3.id] }

    it 'removes all extra entity from db' do
      subject.clean_extra_data

      expect(facility1.class.all).to match_array([facility1, facility3])
    end
  end
end
