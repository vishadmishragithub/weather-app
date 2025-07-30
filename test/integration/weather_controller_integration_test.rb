require "test_helper"

class WeatherControllerIntegrationTest < ActionDispatch::IntegrationTest
  test "should show the weather page" do
    stub_successfull_nominatim_response("test")
    get weather_path, params: { zipcode: "test" }

    assert_dom "h1", "Current temperature - 12 C"
  end

  test "should redirect to the root page" do
    stub_failed_nominatim_response("test")
    get weather_path, params: { zipcode: "test" }

    assert_redirected_to(root_path)
  end
end
