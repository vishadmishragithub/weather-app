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
    assert_equal(21, weather.current_temp)
    assert_equal(date, weather.daily_high_low_temp[0].date)
    assert_equal(25, weather.daily_high_low_temp[0].high)
    assert_equal(19, weather.daily_high_low_temp[0].low)
  end

  test "it raises error when open meteo responds with error" do
    coordinate = CoordinateDto.new(1, 2)

   stub_request(:get, "https://api.open-meteo.com/v1/forecast")
    .with(query: hash_including({}))
    .to_return(body: "[]", status: 500)

    assert_raises(WeatherController::ForcastServiceError) { OpenMeteoForcastService.new.get_forcast(coordinate) }
  end
end
