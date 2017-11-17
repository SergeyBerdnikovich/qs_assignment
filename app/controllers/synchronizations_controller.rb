class SynchronizationsController < ApplicationController
  def new
    synchronizer.synchronize_data

    if synchronizer.success?
      redirect_to facilities_path, notice: synchronizer.success_message
    else
      redirect_to facilities_path, error: synchronizer.error_message
    end
  end

  private

  def synchronizer
    @synchronizer ||= Synchronizers::FacilitySynchronizer.new(current_facility)
  end

  def current_facility
    Facility.find(params[:facility_id])
  end
end
