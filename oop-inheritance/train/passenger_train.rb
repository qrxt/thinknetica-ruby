require_relative "train"
require_relative "../carriage/passenger_carriage"

class PassengerTrain < Train
  def initialize(number)
    super(number)
  end

  def add_carriage(carriage)
    super if carriage.is_a?(PassengerCarriage)
  end
end
