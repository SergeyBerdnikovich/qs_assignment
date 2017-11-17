require 'rails_helper'

describe Synchronizers::AvailableUnitTypesSynchronizer do
  subject { described_class.new(facility) }

  let(:facility) { create(:facility) }

  describe '#synchronize_available_unit_types' do
    let(:request_sender) { double(:request_sender, parsed_response: parsed_response, error_message: 'error message') }
    let(:parsed_response) do
      [
        {
          cs_type_description: 'test description',
          i_type_id:           '111'
        }
      ]
    end
    let!(:facility_info) { create(:facility_info, facility: facility) }

    before do
      allow(subject).to        receive(:request_sender).and_return(request_sender)
      allow(request_sender).to receive(:send_request)
      allow(request_sender).to receive(:success?).and_return(true)
      allow(subject).to        receive(:clean_extra_data)
    end

    it 'fetches available_unit_types' do
      expect(request_sender).to receive(:send_request)

      subject.synchronize_available_unit_types
    end

    context 'when available_unit_types is fetched' do
      context 'when available_unit_types is already stored' do
        let!(:available_unit_type) { create(:available_unit_type, facility_info: facility_info) }
        let(:parsed_response) do
          [
            {
              cs_type_description: 'test description',
              i_type_id:           available_unit_type.i_type_id
            }
          ]
        end

        it 'updates available_unit_types' do
          subject.synchronize_available_unit_types

          expect(available_unit_type.reload.cs_type_description).to eq(parsed_response.first[:cs_type_description])
        end
      end

      context 'when available_unit_types are not stored yet' do
        it 'creates new available_unit_types' do
          expect { subject.synchronize_available_unit_types }.to change { AvailableUnitType.count }.from(0).to(1)
        end
      end

      it 'cleans extra data' do
        expect(subject).to receive(:clean_extra_data)

        subject.synchronize_available_unit_types
      end
    end

    context 'when available_unit_types are not fetched' do
      before { allow(request_sender).to receive(:success?).and_return(false) }

      it 'raises an error' do
        expect { subject.synchronize_available_unit_types }
          .to raise_error(Errors::AvailableUnitTypesSynchronizationError, request_sender.error_message)
      end
    end
  end
end
