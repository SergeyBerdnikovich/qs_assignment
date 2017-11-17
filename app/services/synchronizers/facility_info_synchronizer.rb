module Synchronizers
  class FacilityInfoSynchronizer
    attr_reader :facility

    def initialize(facility)
      @facility = facility
    end

    def synchronize_facility_info
      fetch_facility_info

      if facility_info_fetched?
        create_or_update_facility_info
        clean_extra_data
      else
        raise_error
      end
    end

    private

    attr_reader :facility_info

    def fetch_facility_info
      request_sender.send_request
    end

    def request_sender
      @request_sender ||= SoapRequestSender.new(:facility_info, request_sender_options)
    end

    def request_sender_options
      { csUser: facility.user, csPassword: facility.password, csSiteName: facility.site }
    end

    def facility_info_fetched?
      request_sender.success?
    end

    def create_or_update_facility_info
      facility_info_params = request_sender.parsed_response
      @facility_info       = FacilityInfo.find_or_initialize_by(facility_id: facility.id,
                                                                cs_site_name: facility_info_params[:cs_site_name])

      facility_info.update_attributes!(facility_info_params.compact)
    end

    def clean_extra_data
      ExtraDataCleaner.new(:facility_info, facility_info.id).clean_extra_data
    end

    def raise_error
      raise(Errors::FacilityInfoSynchronizationError, request_sender.error_message)
    end
  end
end
