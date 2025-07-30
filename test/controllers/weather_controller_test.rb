require "test_helper"

class WeatherControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    stub_successfull_nominatim_response("test")
    get weather_path, params: { zipcode: "test" }
    assert_response :success
  end

  # test "should render Current tempreture" do
  #   get weather_path, params: { zipcode: "test" }
  #   assert_dom "h1", "Current temperature - 12 C"
  # end

  test "should redirect if address not found" do
    stub_failed_nominatim_response("error")
    get weather_path, params: { zipcode: "error" }
    assert_response :redirect
    assert_match root_path, @response.redirect_url
  end
end
