require "test_helper"

class WeatherControllerTest < ActionDispatch::IntegrationTest
  def setup
      Rails.cache.clear
  end

  test "should validate empty zipcode" do
    get weather_path, params: { zipcode: "" }
    assert_response :redirect
    assert_match root_path, @response.redirect_url
    assert_equal "Address not found", flash[:notice]
  end

  test "should validate zipcode is passed" do
    get weather_path
    assert_response :redirect
    assert_match root_path, @response.redirect_url
    assert_equal "Address not found", flash[:notice]
  end

  test "should show the weather page when cached" do
    weather = ForcastDto.new(
          21,
          [ DailyHighLowTempDto.new(Date.new(2025, 1, 1), 25, 19) ])
    Rails.cache.write("WeatherController:test", weather)

    get weather_path, params: { zipcode: "test" }
    assert_dom "h1", "Weather for test is cached"
    assert_dom "h3", "Current temperature - 21 C"
  end

  test "should return current tempreture with stub and cache" do
    test_date = Date.new(2025, 1, 1)
    expected_current_temp = 21
    expected_high_temp = 25
    expected_low_temp = 19
    coordinate = CoordinateDto.new(1, 2)

    geocode_service = Minitest::Mock.new
    geocode_service.expect(:get_lat_lon, coordinate, [ "test" ])
    forecast_service = Minitest::Mock.new
    forecast_service.expect(
      :get_forcast,
        ForcastDto.new(
          expected_current_temp,
          [ DailyHighLowTempDto.new(test_date, expected_high_temp, expected_low_temp) ]),
      [ coordinate ])

    controller = WeatherController.new(geocode_service, forecast_service)
    controller.params = ActionController::Parameters.new(zipcode: "test")

    refute Rails.cache.exist?("WeatherController:test")
    weather = controller.show
    assert_equal(expected_current_temp, weather.current_temp)
    assert_equal(test_date, weather.daily_high_low_temp[0].date)
    assert_equal(expected_high_temp, weather.daily_high_low_temp[0].high)
    assert_equal(expected_low_temp, weather.daily_high_low_temp[0].low)
    assert Rails.cache.exist?("WeatherController:test")
  end

  test "should return cached value if cache exists" do
    test_date = Date.new(2025, 1, 1)
    expected_current_temp = 21
    expected_high_temp = 25
    expected_low_temp = 19

    geocode_service = Minitest::Mock.new
    forecast_service = Minitest::Mock.new

    weather = ForcastDto.new(
          expected_current_temp,
          [ DailyHighLowTempDto.new(test_date, expected_high_temp, expected_low_temp) ])

    controller = WeatherController.new(geocode_service, forecast_service)
    controller.params = ActionController::Parameters.new(zipcode: "test")

    Rails.cache.write("WeatherController:test", weather)
    weather = controller.show
    assert_equal(expected_current_temp, weather.current_temp)
  end
end
