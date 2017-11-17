module Errors
  class LoginError < StandardError; end
  class FacilityInfoSynchronizationError < StandardError; end
  class AvailableUnitsSynchronizationError < StandardError; end
  class AvailableUnitTypesSynchronizationError < StandardError; end
end
