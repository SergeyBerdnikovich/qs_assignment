module Synchronizers
  class FacilitySynchronizer
    SUCCESS_MESSAGE = 'Synchronized!'.freeze

    attr_reader :facility
    attr_reader :error_message

    def initialize(facility)
      @facility = facility
    end

    def synchronize_data
      check_login_ability

      synchronize_facility_info
      synchronize_available_unit_types
      synchronize_available_units
    rescue => error
      fill_error_message(error)
    end

    def success?
      error_message.blank?
    end

    def success_message
      SUCCESS_MESSAGE
    end

    private

    def check_login_ability
      FacilityLoginChecker.new(facility).check_login_ability
    end

    def synchronize_facility_info
      FacilityInfoSynchronizer.new(facility).synchronize_facility_info
    end

    def synchronize_available_unit_types
      AvailableUnitTypesSynchronizer.new(facility).synchronize_available_unit_types
    end

    def synchronize_available_units
      AvailableUnitsSynchronizer.new(facility).synchronize_available_units
    end

    def fill_error_message(error)
      @error_message = error.message
    end
  end
end
