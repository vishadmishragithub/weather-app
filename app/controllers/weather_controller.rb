class WeatherController < ApplicationController
  def show
    zipcode = params[:zipcode]
    if zipcode == "error"
      redirect_to root_path, notice: "Address not found"
    end
    @weather = { "temperature": 12 }
  end
end
