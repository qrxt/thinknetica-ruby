# frozen_string_literal: true

require_relative 'train'
require_relative '../carriage/cargo_carriage'

class CargoTrain < Train
  def add_carriage(carriage)
    super if carriage.is_a?(CargoCarriage)
  end

  protected

  # метод для внутреннего использования, снаружи не используется
  def initial_speed
    40
  end
end
