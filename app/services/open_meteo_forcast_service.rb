class OpenMeteoForcastService
    include ForcastService

    require "uri"
    require "net/http"
    @@url = "https://api.open-meteo.com/v1/forecast"
    @@key_for_current = "current"
    @@key_for_daily = "daily"
    @@key_for_time = "time"
    @@key_for_temperature = "temperature_2m"
    @@key_for_max_temperature = "temperature_2m_max"
    @@key_for_min_temperature = "temperature_2m_min"
    @@daily_forcast_options = "#{@@key_for_max_temperature},#{@@key_for_min_temperature}"
    @@current_forcast_options = "#{@@key_for_temperature}"
    @@requested_timezone = "auto"
    @@forcast_days = 7

    # Forcast service from open meteo - https://open-meteo.com/en/docs?
    def get_forcast(coordinate)
        response = request_forcast(coordinate)
        build_forcast_dto(response)
    end

    private

    def request_forcast(coordinate)
        uri = URI(@@url)
        uri.query = URI.encode_www_form(build_query_params(coordinate))
        response = Net::HTTP.get_response(uri)

        # Verify response code
        raise WeatherController::ForcastServiceError.new("Error fetching forecast please try again later") unless response.is_a?(Net::HTTPSuccess)
        response
    end

    # Response structure can be seen in test_helper.rb#37
    def build_forcast_dto(response)
        parsed_json = JSON.parse(response.body)
        ForcastDto.new(
          parsed_json[@@key_for_current][@@key_for_temperature],
          build_daily_high_low_temp(parsed_json)
        )
    end

    def build_query_params(coordinate)
      {
          latitude: coordinate.lat.to_s,
          longitude: coordinate.lon.to_s,
          daily: @@daily_forcast_options, # options for the forcast for future days
          current: @@current_forcast_options, # options for todays forcast
          timezone: @@requested_timezone,
          forecast_days: @@forcast_days # number of days to fetch
      }
    end

    def build_daily_high_low_temp(parsed_response)
      parsed_response[@@key_for_daily][@@key_for_time].map.with_index  do  |item, index|
          DailyHighLowTempDto.new(
            Date.parse(parsed_response[@@key_for_daily][@@key_for_time][index]),
            parsed_response[@@key_for_daily][@@key_for_max_temperature][index],
            parsed_response[@@key_for_daily][@@key_for_min_temperature][index])
      end
  end
end
