require "test_helper"

class WeatherControllerIntegrationTest < ActionDispatch::IntegrationTest
  test "should show the weather page" do
    coordinate = CoordinateDto.new(1, 2)
    stub_successfull_nominatim_response("test", coordinate: coordinate)
    stub_successfull_open_meteo_response(coordinate, expected_current_temp: 21)
    get weather_path, params: { zipcode: "test" }

    assert_dom "h3", "Current temperature - 21 C"
  end

  test "should redirect to the root page" do
    stub_failed_nominatim_response("test")
    get weather_path, params: { zipcode: "test" }

    assert_redirected_to(root_path)
  end
end
