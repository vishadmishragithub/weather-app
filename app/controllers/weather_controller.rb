class WeatherController < ApplicationController
  class AddressNotFound < StandardError
  end

  class ForcastServiceError < StandardError
  end

  def initialize(geocode_service = NominatimGeocodeService.new,
    forcast_service = OpenMeteoForcastService.new)
      @geocode_service = geocode_service
      @forcast_service = forcast_service
  end

  def show
    @zipcode = params[:zipcode]
    if @zipcode.nil? || @zipcode.empty?
      return redirect_to root_path, notice: "Address not found"
    end

    coordinate = @geocode_service.get_lat_lon(@zipcode)
    @weather = @forcast_service.get_forcast(coordinate)
  rescue AddressNotFound, ForcastServiceError => e
      # Log zipcode and error to investage further
      puts @zipcode, e unless Rails.env.test?
      redirect_to root_path, notice: e.message
  end
end
