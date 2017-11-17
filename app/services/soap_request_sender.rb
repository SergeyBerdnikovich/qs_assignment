class SoapRequestSender
  WSDL_URL = "#{Rails.public_path}/QuikStorWebServiceSS.xml".freeze

  attr_reader :method_name, :options
  attr_reader :parsed_response, :error_message

  def initialize(method_name, options = {})
    @method_name = method_name
    @wrapper     = options.delete(:wrapper)
    @options     = options
  end

  def send_request
    send_soap_request
    parse_response
  rescue Savon::SOAPFault, StandardError => error
    fill_error_message(error)
  end

  def success?
    error_message.blank?
  end

  private

  attr_reader :wrapper, :raw_response

  def send_soap_request
    @raw_response = client.call(method_name, message: options)
  end

  def client
    @@client ||= Savon.client(wsdl: WSDL_URL, log_level: :debug, logger: Rails.logger, read_timeout: 10)
  end

  def parse_response
    @parsed_response = raw_response.body[:"#{method_name}_response"][:"#{method_name}_result"]
    @parsed_response = @parsed_response[wrapper] if @parsed_response.present? && wrapper
  end

  def fill_error_message(error)
    @error_message = error.message
  end
end
