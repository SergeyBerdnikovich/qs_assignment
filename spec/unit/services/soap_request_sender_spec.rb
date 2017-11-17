require 'rails_helper'

describe SoapRequestSender do
  subject { described_class.new(method_name, options) }

  let(:method_name) { :soap_method_name }
  let(:options)     { {} }

  describe '#send_request' do
    let(:client)       { double(:client) }
    let(:raw_response) { double(:raw_response, body: body) }
    let(:body) do
      {
        :"#{method_name}_response" => {
          :"#{method_name}_result" => parsed_response
        }
      }
    end
    let(:parsed_response) { { test: :test } }

    before do
      allow(subject).to receive(:client).and_return(client)
      allow(client).to  receive(:call).with(method_name, message: options).and_return(raw_response)
    end

    it 'sends soap request' do
      expect(client).to receive(:call).with(method_name, message: options).and_return(raw_response)

      subject.send_request
    end

    it 'parses response' do
      expect(raw_response).to receive(:body).and_return(body)

      subject.send_request

      expect(subject.parsed_response).to eq(parsed_response)
    end

    context 'when wrapper options is set' do
      let(:options)                  { { wrapper: :my_wrapper } }
      let(:parsed_response)          { { my_wrapper: response_without_wrapper } }
      let(:response_without_wrapper) { { test: :test } }

      it 'fetches data from wrapper inside body' do
        subject.send_request

        expect(subject.parsed_response).to eq(response_without_wrapper)
      end
    end

    context 'when some error is occurred' do
      let(:error_message) { 'error message' }

      before { allow(client).to receive(:call).with(method_name, message: options).and_raise(error_message) }

      it 'fills the error message' do
        subject.send_request

        expect(subject.error_message).to eq(error_message)
      end
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
