require 'rails_helper'

describe Synchronizers::AvailableUnitsSynchronizer do
  subject { described_class.new(facility) }

  let(:facility) { create(:facility) }

  describe '#synchronize_available_units' do
    let(:request_sender) { double(:request_sender, parsed_response: parsed_response, error_message: 'error message') }
    let(:parsed_response) do
      [
        {
          d_rent:     20.9,
          cs_unit_id: '111'
        }
      ]
    end
    let(:facility_info)        { create(:facility_info, facility: facility) }
    let!(:available_unit_type) { create(:available_unit_type, facility_info: facility_info) }

    before do
      allow(subject).to        receive(:request_sender).and_return(request_sender)
      allow(request_sender).to receive(:send_request)
      allow(request_sender).to receive(:success?).and_return(true)
      allow(subject).to        receive(:clean_extra_data)
    end

    it 'fetches available_units' do
      expect(request_sender).to receive(:send_request)

      subject.synchronize_available_units
    end

    context 'when available_units are fetched' do
      context 'when available_units are already stored' do
        let!(:available_unit) { create(:available_unit, available_unit_type: available_unit_type) }
        let(:parsed_response) do
          [
            {
              d_rent:     30.1,
              cs_unit_id: available_unit.cs_unit_id
            }
          ]
        end

        it 'updates available_units' do
          subject.synchronize_available_units

          expect(available_unit.reload.d_rent).to eq(parsed_response.first[:d_rent])
        end
      end

      context 'when available_units are not stored yet' do
        it 'creates new available_units' do
          expect { subject.synchronize_available_units }
            .to change { AvailableUnit.count }.from(0).to(1)
        end
      end

      it 'cleans extra data' do
        expect(subject).to receive(:clean_extra_data)

        subject.synchronize_available_units
      end
    end

    context 'when available_units are not fetched' do
      before { allow(request_sender).to receive(:success?).and_return(false) }

      it 'raises an error' do
        expect { subject.synchronize_available_units }
          .to raise_error(Errors::AvailableUnitsSynchronizationError, request_sender.error_message)
      end
    end
  end
end
