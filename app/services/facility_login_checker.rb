class FacilityLoginChecker
  ERROR_MESSAGE    = 'Facility login is not available!'.freeze
  SUCCESS_RESPONSE = 'Hello World '.freeze

  attr_reader :facility

  def initialize(facility)
    @facility = facility
  end

  def check_login_ability
    send_hello_world_password_request

    raise_error if login_unavailable?
  end

  private

  def send_hello_world_password_request
    request_sender.send_request
  end

  def request_sender
    @request_sender ||= SoapRequestSender.new(:hello_world_password, request_sender_options)
  end

  def request_sender_options
    { csUser: facility.user, csPassword: facility.password, csSiteName: facility.site }
  end

  def raise_error
    raise(Errors::LoginError, ERROR_MESSAGE)
  end

  def login_unavailable?
    request_sender.parsed_response != SUCCESS_RESPONSE
  end
end
