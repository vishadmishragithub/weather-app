require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get root_path
    assert_dom "h1", "Weather App"
    assert_response :success
  end
end
