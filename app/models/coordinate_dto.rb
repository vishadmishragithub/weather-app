class CoordinateDto extend ActiveModel::Model
  attr_accessor :lat, :lon

  def initialize(lat, lon)
    @lat = lat
    @lon = lon
  end
end
