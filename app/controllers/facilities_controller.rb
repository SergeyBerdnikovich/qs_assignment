class FacilitiesController < ApplicationController
  def index
    @facilities = Facility.all
  end
end
