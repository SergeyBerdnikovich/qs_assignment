module Synchronizers
  class AvailableUnitTypesSynchronizer
    attr_reader :facility

    def initialize(facility)
      @facility         = facility
      @synchronized_ids = []
    end

    def synchronize_available_unit_types
      fetch_available_unit_types

      if available_unit_types_fetched?
        create_or_update_available_unit_types
        clean_extra_data
      else
        raise_error
      end
    end

    private

    attr_reader :synchronized_ids

    def fetch_available_unit_types
      request_sender.send_request
    end

    def request_sender
      @request_sender ||= SoapRequestSender.new(:available_unit_types, request_sender_options)
    end

    def request_sender_options
      {
        csUser:     facility.user,
        csPassword: facility.password,
        csSiteName: facility.site,
        wrapper:    :available_unit_types_st
      }
    end

    def available_unit_types_fetched?
      request_sender.success?
    end

    def create_or_update_available_unit_types
      Array.wrap(request_sender.parsed_response).each do |available_unit_type_params|
        available_unit_type = AvailableUnitType.find_or_initialize_by(facility_info_id: facility.facility_info_id,
                                                                      i_type_id: available_unit_type_params[:i_type_id])

        available_unit_type.update_attributes!(available_unit_type_params.compact)

        synchronized_ids << available_unit_type.id
      end
    end

    def clean_extra_data
      ExtraDataCleaner.new(:available_unit_type, synchronized_ids).clean_extra_data
    end

    def raise_error
      raise(Errors::AvailableUnitTypesSynchronizationError, request_sender.error_message)
    end
  end
end
