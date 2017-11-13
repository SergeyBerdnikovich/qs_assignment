class SynchronizationsController < ApplicationController
  def new
    @facility = Facility.find(params[:facility_id])
    Fetcher.new(@facility).run
    redirect_to facilities_path
  end
end
