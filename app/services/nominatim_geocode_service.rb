class NominatimGeocodeService
    include GeocodeService

    require "uri"
    require "net/http"
    @@url = "https://nominatim.openstreetmap.org/search.php"
    @@query_params = { format: "jsonv2", addressdetails: 1 }
    @@user_agent = { "User-Agent" => "Mozilla/5.0 (compatible; WeatherApp/1.0)" }

    # Geocode service from nominatim - https://nominatim.org/release-docs/develop/api/Search/
    def get_lat_lon(zipcode)
        response = request_lat_lon(zipcode)
        get_coordinate(response)
    end

    private

    def request_lat_lon(zipcode)
        uri = URI(@@url)
        query_params = { "postalcode" => "#{zipcode}" }.merge(@@query_params)
        uri.query = URI.encode_www_form(query_params)
        response = Net::HTTP.get_response(uri, @@user_agent)

        # Verify response code
        raise WeatherController::AddressNotFound.new("Adress Not Found") unless response.is_a?(Net::HTTPSuccess)
        response
    end

    def get_coordinate(response)
        parsed_json = JSON.parse(response.body)
        # Response is empty if zipcode is invalid (Ex: error)
        raise WeatherController::AddressNotFound.new("Adress Not Found") if parsed_json[0].nil?

        CoordinateDto.new(parsed_json[0]["lat"], parsed_json[0]["lon"])
    end
end
