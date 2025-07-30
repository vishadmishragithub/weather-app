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

    def stub_successfull_nominatim_response(zipcode)
      stub_request(:get, "https://nominatim.openstreetmap.org/search.php")
        .with(query: { "addressdetails" => 1, "format" => "jsonv2", "postalcode" => zipcode })
        .to_return(body: "[{\"lat\": 1, \"lon\": 2}]", status: 200)
    end

    def stub_failed_nominatim_response(zipcode)
      stub_request(:get, "https://nominatim.openstreetmap.org/search.php")
        .with(query: { "addressdetails" => 1, "format" => "jsonv2", "postalcode" => zipcode })
        .to_return(body: "[]", status: 200)
    end
  end
end
