class NominatimGeocodeService
    include GeocodeService

    require "uri"
    require "net/http"
    @@lat_key = "lat"
    @@lon_key = "lon"
    @@response_format = "jsonv2"
    @@url = "https://nominatim.openstreetmap.org/search.php"
    @@user_agent = { "User-Agent" => "Mozilla/5.0 (compatible; WeatherApp/1.0)" }

    # Geocode service from nominatim - https://nominatim.org/release-docs/develop/api/Search/
    def get_lat_lon(zipcode)
        response = request_lat_lon(zipcode)
        build_coordiate_dto(response)
    end

    private

    def request_lat_lon(zipcode)
        uri = URI(@@url)
        uri.query = URI.encode_www_form(build_query_params(zipcode))
        response = Net::HTTP.get_response(uri, @@user_agent)

        # Verify response code
        raise WeatherController::AddressNotFound.new("Adress Not Found") unless response.is_a?(Net::HTTPSuccess)
        response
    end

    def build_query_params(zipcode)
        {
            format: @@response_format,
            addressdetails: 1,
            postalcode: zipcode.to_s
        }
    end

    def build_coordiate_dto(response)
        parsed_json = JSON.parse(response.body)
        # Response is empty if zipcode is invalid (Ex: error)
        raise WeatherController::AddressNotFound.new("Adress Not Found") if parsed_json[0].nil?

        CoordinateDto.new(parsed_json[0][@@lat_key], parsed_json[0][@@lon_key])
    end
end
