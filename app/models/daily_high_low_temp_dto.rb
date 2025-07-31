class DailyHighLowTempDto extend ActiveModel::Model
  attr_accessor :date, :high, :low

  def initialize(date, high, low)
    @date = date
    @high = high
    @low = low
  end
end
