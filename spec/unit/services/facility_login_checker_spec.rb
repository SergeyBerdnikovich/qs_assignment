require 'rails_helper'

describe FacilityLoginChecker do
  subject { described_class.new(facility) }

  let(:facility) { double(:facility) }

  describe '#check_login_ability' do
    let(:request_sender) { double(:request_sender, parsed_response: parsed_response) }

    before do
      allow(subject).to        receive(:request_sender).and_return(request_sender)
      allow(request_sender).to receive(:send_request)
    end

    context 'when login is available' do
      let(:parsed_response) { described_class::SUCCESS_RESPONSE }

      it 'sends hello_world_password_request' do
        expect(request_sender).to receive(:send_request)

        subject.check_login_ability
      end
    end

    context 'when login is not available' do
      let(:parsed_response) { 'bad response' }

      it 'sends hello_world_password_request' do
        expect { subject.check_login_ability }.to raise_error(Errors::LoginError, described_class::ERROR_MESSAGE)
      end
    end
  end
end
