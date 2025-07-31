class ForcastDto extend ActiveModel::Model
  attr_accessor :current_temp, :daily_high_low_temp

  def initialize(current_temp, daily_high_low_temp)
    @current_temp = current_temp
    @daily_high_low_temp = daily_high_low_temp
  end
end
