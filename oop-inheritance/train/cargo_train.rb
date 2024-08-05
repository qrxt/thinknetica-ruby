require_relative "train"
require_relative "../carriage/cargo_carriage"

class CargoTrain < Train
  def initialize(number)
    super(number)
  end

  def add_carriage(carriage)
    super if carriage.is_a?(CargoCarriage)
  end
end
