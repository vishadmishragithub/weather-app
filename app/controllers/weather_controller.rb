class WeatherController < ApplicationController
  class AddressNotFound < StandardError
  end

  def initialize(geocode_service = NominatimGeocodeService.new)
      @geocode_service = geocode_service
  end

  def show
    zipcode = params[:zipcode]
    if zipcode.nil? || zipcode.empty?
      return redirect_to root_path, notice: "Address not found"
    end

    coordinates = @geocode_service.get_lat_lon(zipcode)
    @weather = { "temperature": 12 }
  rescue AddressNotFound => e
      redirect_to root_path, notice: e.message
  end
end
