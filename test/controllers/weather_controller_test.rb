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
    geocode_service = Minitest::Mock.new
    geocode_service.expect(:get_lat_lon, CoordinateDto.new(1, 2), [ "test" ])

    controller = WeatherController.new(geocode_service)
    controller.params = ActionController::Parameters.new(zipcode: "test")

    weather = controller.show
    assert weather[:temperature], 12
  end
end
