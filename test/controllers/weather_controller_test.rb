require "test_helper"

class WeatherControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get weather_path, params: { zipcode: "test" }
    assert_dom "h1", "Current temperature - 12 C"
    assert_response :success
  end
end
