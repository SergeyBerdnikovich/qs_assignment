module Synchronizers
  class AvailableUnitsSynchronizer
    attr_reader :facility

    def initialize(facility)
      @facility         = facility
      @synchronized_ids = []
    end

    def synchronize_available_units
      synchronize_available_units_per_unit_type
      clean_extra_data
    end

    private

    attr_reader :synchronized_ids, :i_type_id

    def synchronize_available_units_per_unit_type
      facility.available_unit_types.each do |available_unit_type|
        synchronize_units_for_unit_type(available_unit_type)
      end
    end

    def synchronize_units_for_unit_type(available_unit_type)
      fill_i_type_id(available_unit_type.i_type_id)

      fetch_available_units

      if available_units_fetched?
        create_or_update_available_units(available_unit_type.id)
      else
        raise_error
      end

      clean_request_sender
    end

    def fill_i_type_id(i_type_id)
      @i_type_id = i_type_id
    end

    def fetch_available_units
      request_sender.send_request
    end

    def request_sender
      @request_sender ||= SoapRequestSender.new(:available_units, request_sender_options)
    end

    def request_sender_options
      {
        csUser:     facility.user,
        csPassword: facility.password,
        csSiteName: facility.site,
        iTypeID:    i_type_id,
        wrapper:    :available_units_st
      }
    end

    def available_units_fetched?
      request_sender.success?
    end

    def create_or_update_available_units(available_unit_type_id)
      Array.wrap(request_sender.parsed_response).each do |available_unit_params|
        available_unit = AvailableUnit.find_or_initialize_by(available_unit_type_id: available_unit_type_id,
                                                             cs_unit_id: available_unit_params[:cs_unit_id])

        available_unit.update_attributes!(available_unit_params.compact)

        synchronized_ids << available_unit.id
      end
    end

    def raise_error
      raise(Errors::AvailableUnitsSynchronizationError, request_sender.error_message)
    end

    def clean_request_sender
      @request_sender = nil
    end

    def clean_extra_data
      ExtraDataCleaner.new(:available_unit, synchronized_ids).clean_extra_data
    end
  end
end
