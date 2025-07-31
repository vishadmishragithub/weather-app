# Abstract service for forcast
module ForcastService extend ActiveSupport::Concern
    def get_forcast(zipcode)
        raise NotImplementedError, "This method must be implemented in child class"
    end
end
