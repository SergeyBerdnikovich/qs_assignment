require 'rails_helper'

describe Synchronizers::FacilitySynchronizer do
  subject { described_class.new(facility) }

  let(:facility) { create(:facility) }

  describe '#synchronize_data' do
    let(:check_login_ability)              { double(:check_login_ability) }
    let(:synchronize_facility_info)        { double(:synchronize_facility_info) }
    let(:synchronize_available_unit_types) { double(:synchronize_available_unit_types) }
    let(:synchronize_available_units)      { double(:synchronize_available_units) }

    before do
      allow(subject).to receive(:check_login_ability).and_return(check_login_ability)
      allow(subject).to receive(:synchronize_facility_info).and_return(synchronize_facility_info)
      allow(subject).to receive(:synchronize_available_unit_types).and_return(synchronize_available_unit_types)
      allow(subject).to receive(:synchronize_available_units).and_return(synchronize_available_units)
    end

    context 'when synchronization is success' do
      it 'checks login_ability' do
        expect(subject).to receive(:check_login_ability).and_return(check_login_ability)

        subject.synchronize_data
      end

      it 'synchronizes facility_info' do
        expect(subject).to receive(:synchronize_facility_info).and_return(synchronize_facility_info)

        subject.synchronize_data
      end

      it 'synchronizes available_unit_types' do
        expect(subject).to receive(:synchronize_available_unit_types).and_return(synchronize_available_unit_types)

        subject.synchronize_data
      end

      it 'synchronizes available_units' do
        expect(subject).to receive(:synchronize_available_units).and_return(synchronize_available_units)

        subject.synchronize_data
      end
    end

    context 'when synchronization is failed' do
      let(:error_message) { 'error message' }

      before { allow(subject).to receive(:check_login_ability).and_raise(error_message) }

      it 'fills the error message' do
        subject.synchronize_data

        expect(subject.error_message).to eq(error_message)
      end
    end
  end

  describe '#success_message' do
    it 'returns success message' do
      expect(subject.success_message).to eq(described_class::SUCCESS_MESSAGE)
    end
  end

  describe '#success?' do
    context 'when error_message is blank' do
      it 'returns true' do
        expect(subject.success?).to be true
      end
    end

    context 'when error_message is present' do
      before { subject.instance_variable_set(:@error_message, 'error message') }

      it 'returns false' do
        expect(subject.success?).to be false
      end
    end
  end
end
