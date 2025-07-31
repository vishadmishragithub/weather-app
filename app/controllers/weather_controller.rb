class WeatherController < ApplicationController
  @@cache_expires_in = 30.minutes
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

    @cached = true
    @weather = Rails.cache.fetch(@zipcode.to_s,
        namespace: WeatherController.to_s,
        expires_at: (Time.now + @@cache_expires_in)
      ) do
      @cached = false
      coordinate = @geocode_service.get_lat_lon(@zipcode)
      @forcast_service.get_forcast(coordinate)
    end
  rescue AddressNotFound, ForcastServiceError => e
      # Log zipcode and error to investage further
      puts @zipcode, e unless Rails.env.test?
      redirect_to root_path, notice: e.message
  end
end
