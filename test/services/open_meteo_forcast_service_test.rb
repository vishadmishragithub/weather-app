require "test_helper"

class OpenMeteoForcastServiceTest < ActiveSupport::TestCase
  test "it returns the weather forcast for valid coordinate" do
    coordinate = CoordinateDto.new(1, 2)
    stub_successfull_open_meteo_response(
      coordinate,
      expected_current_temp: 21,
      expected_high_temp: 25,
      expected_low_temp: 19,
      date: Date.new(2025, 1, 1))

    weather = OpenMeteoForcastService.new.get_forcast(coordinate)
    assert(coordinate.lat == 1, "Wrong coordinate")
    assert(coordinate.lon == 2, "Wrong coordinate")
  end

  test "it raises error when open meteo responds with error" do
    coordinate = CoordinateDto.new(1, 2)

   stub_request(:get, "https://api.open-meteo.com/v1/forecast")
    .with(query: hash_including({}))
    .to_return(body: "[]", status: 500)

    assert_raises(WeatherController::ForcastServiceError) { OpenMeteoForcastService.new.get_forcast(coordinate) }
  end
end
