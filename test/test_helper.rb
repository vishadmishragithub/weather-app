ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "webmock/minitest"
require "minitest/autorun"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    def stub_successfull_nominatim_response(zipcode, coordinate: CoordinateDto.new(1, 2))
      stub_request(:get, "https://nominatim.openstreetmap.org/search.php")
        .with(query: { addressdetails: 1, format: "jsonv2", postalcode: zipcode })
        .to_return(body: "[{\"lat\": #{coordinate.lat}, \"lon\": #{coordinate.lon}}]", status: 200)
    end

    def stub_successfull_open_meteo_response(
        coordinate,
        expected_current_temp: 21,
        expected_high_temp: 25,
        expected_low_temp: 19,
        date: Date.new(2025, 1, 1))
      stub_request(:get, "https://api.open-meteo.com/v1/forecast")
        .with(query:
          {
              current: "temperature_2m",
              daily: "temperature_2m_max,temperature_2m_min",
              forecast_days: 7,
              latitude: coordinate.lat,
              longitude: coordinate.lon,
              timezone: "auto"
          })
        .to_return(
          body: {
          current: { temperature_2m: expected_current_temp },
          daily:
            {
              time: [ date ],
              temperature_2m_max: [ expected_high_temp ],
              temperature_2m_min: [ expected_low_temp ]
            }
        }.to_json,
        status: 200)
    end

    def stub_failed_nominatim_response(zipcode)
      stub_request(:get, "https://nominatim.openstreetmap.org/search.php")
        .with(query: { addressdetails: 1, format: "jsonv2", postalcode: zipcode })
        .to_return(body: "[]", status: 200)
    end
  end
end
