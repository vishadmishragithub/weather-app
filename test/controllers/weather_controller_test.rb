require "test_helper"

class WeatherControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get weather_path, params: {zipcode: "test"}
    assert_response :success
  end
end
