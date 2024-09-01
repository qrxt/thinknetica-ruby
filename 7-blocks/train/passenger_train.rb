# frozen_string_literal: true

require_relative 'train'
require_relative '../carriage/passenger_carriage'

class PassengerTrain < Train
  def add_carriage(carriage)
    super if carriage.is_a?(PassengerCarriage)
  end

  def type_label
    'пассажирский'
  end

  protected

  # метод для внутреннего использования, снаружи не используется
  def initial_speed
    65
  end
end
