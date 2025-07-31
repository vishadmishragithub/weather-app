require "test_helper"

class WeatherControllerTest < ActionDispatch::IntegrationTest
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


  test "should return current tempreture with stub" do
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

    weather = controller.show
    assert weather.current_temp, expected_current_temp
    assert weather.daily_high_low_temp[0].date, test_date
    assert weather.daily_high_low_temp[0].high, expected_high_temp
    assert weather.daily_high_low_temp[0].low, expected_low_temp
  end
end
