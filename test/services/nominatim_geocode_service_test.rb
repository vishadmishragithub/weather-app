require "test_helper"

class NominatimGeocodeServiceTest < ActiveSupport::TestCase
  test "it returns the lat lon for a valid zipcode" do
    stub_successfull_nominatim_response("test")

    coordinate = NominatimGeocodeService.new.get_lat_lon("test")
    assert_equal(1, coordinate.lat)
    assert_equal(2, coordinate.lon)
  end

  test "it raises error for a fake zipcode" do
    stub_failed_nominatim_response("error")

    assert_raises(WeatherController::AddressNotFound) { NominatimGeocodeService.new.get_lat_lon("error") }
  end

  test "it raises error when nomatim responds with error" do
   stub_request(:get, "https://nominatim.openstreetmap.org/search.php")
    .with(query: { addressdetails: 1, format: "jsonv2", postalcode: "error" })
    .to_return(body: "[]", status: 500)

    assert_raises(WeatherController::AddressNotFound) { NominatimGeocodeService.new.get_lat_lon("error") }
  end
end
