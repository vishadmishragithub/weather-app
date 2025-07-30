# Abstract service for geocoding
module GeocodeService extend ActiveSupport::Concern
    def get_lat_lon(zipcode)
        raise NotImplementedError, "This method must be implemented in child class"
    end
end
