require 'rails_helper'

describe Synchronizers::FacilityInfoSynchronizer do
  subject { described_class.new(facility) }

  let(:facility) { create(:facility) }

  describe '#synchronize_facility_info' do
    let(:request_sender) { double(:request_sender, parsed_response: parsed_response, error_message: 'error message') }
    let(:parsed_response) do
      {
        cs_site_name: 'Site Name'
      }
    end

    before do
      allow(subject).to        receive(:request_sender).and_return(request_sender)
      allow(request_sender).to receive(:send_request)
      allow(request_sender).to receive(:success?).and_return(true)
      allow(subject).to        receive(:clean_extra_data)
    end

    it 'fetches facility_info' do
      expect(request_sender).to receive(:send_request)

      subject.synchronize_facility_info
    end

    context 'when facility_info is fetched' do
      context 'when facility_info is already stored' do
        let!(:facility_info) { create(:facility_info, facility: facility) }
        let(:parsed_response) do
          {
            cs_site_name: facility_info.cs_site_name,
            cs_site_city: 'test'
          }
        end

        it 'updates facility_info' do
          subject.synchronize_facility_info

          expect(facility_info.reload.cs_site_city).to eq(parsed_response[:cs_site_city])
        end
      end

      context 'when facility_info is not stored yet' do
        it 'creates new facility_info' do
          expect { subject.synchronize_facility_info }.to change { FacilityInfo.count }.from(0).to(1)
        end
      end

      it 'cleans extra data' do
        expect(subject).to receive(:clean_extra_data)

        subject.synchronize_facility_info
      end
    end

    context 'when facility_info is not fetched' do
      before { allow(request_sender).to receive(:success?).and_return(false) }

      it 'raises an error' do
        expect { subject.synchronize_facility_info }.to raise_error(Errors::FacilityInfoSynchronizationError,
                                                                    request_sender.error_message)
      end
    end
  end
end
