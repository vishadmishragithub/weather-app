require "test_helper"

class OpenMeteoForcastServiceTest < ActiveSupport::TestCase
  test "it returns the weather forcast for valid coordinate" do
    coordinate = CoordinateDto.new(1, 2)
    date = Date.new(2025, 1, 1)
    stub_successfull_open_meteo_response(
      coordinate,
      expected_current_temp: 21,
      expected_high_temp: 25,
      expected_low_temp: 19,
      date: date)

    weather = OpenMeteoForcastService.new.get_forcast(coordinate)
    assert(weather.current_temp == 21, "Wrong weather")
    assert(weather.daily_high_low_temp[0].date == date, "Wrong high low forcast date")
    assert(weather.daily_high_low_temp[0].high == 25, "Wrong high low forcast high")
    assert(weather.daily_high_low_temp[0].low == 19, "Wrong high low forcast low")
  end

  test "it raises error when open meteo responds with error" do
    coordinate = CoordinateDto.new(1, 2)

   stub_request(:get, "https://api.open-meteo.com/v1/forecast")
    .with(query: hash_including({}))
    .to_return(body: "[]", status: 500)

    assert_raises(WeatherController::ForcastServiceError) { OpenMeteoForcastService.new.get_forcast(coordinate) }
  end
end
