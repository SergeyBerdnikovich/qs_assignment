class Fetcher
  def initialize(facility)
    @facility = facility
  end

  def run
    # Example if usage
    op = CheckLoginOperation.new(@facility)
    op.perform
    # Write sync logic here
  end
end

class Operation
  def initialize(facility)
    @client = Savon.client(wsdl: ENV.fetch('QUIKSTOR_API_WSDL', 'https://sc.quikstor.com/eComm3ServiceSS/QuikStorWebServiceSS.asmx?wsdl'),
      ssl_verify_mode: :peer, log_level: :debug, logger: Rails.logger)
    @facility = facility
  end

  def headers
    { csUser: @facility.user, csPassword: @facility.password, csSiteName: @facility.site }
  end

  def perform(options = {})
    response = call(options)
    if error?(response)
      return nil
    else
      block_given? ? (yield response) : (return response)
    end
  end

  private

  def call(options)
    @raw_response = @client.call(method_name, message: headers.merge(options))
    parse_response(@raw_response)
  rescue Savon::SOAPFault, StandardError => e
    { success: false, message: e.message, stop: true }
  end

  def parse_response(raw_response)
    raw_response.body[:"#{method_name}_response"][:"#{method_name}_result"]
  end

  def error?(response)
    response.blank? || response[:stop]
  end
end

class CheckLoginOperation < Operation
  def method_name
    :hello_world_password
  end

  def error?(response)
    response.blank? || response != 'Hello World '
  end
end