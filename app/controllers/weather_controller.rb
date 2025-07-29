class WeatherController < ApplicationController
  def show
    zipcode = params[:zipcode]
    @weather = { "temperature": 12 }
  end
end
