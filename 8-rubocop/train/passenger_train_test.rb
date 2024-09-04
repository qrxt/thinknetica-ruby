# frozen_string_literal: true

require 'test/unit'

require_relative 'passenger_train'
require_relative '../carriage/passenger_carriage'
require_relative '../carriage/cargo_carriage'

class TestTrain < Test::Unit::TestCase
  def test_passenger_train_initial
    passenger_train = PassengerTrain.new('123-01')

    assert_equal('123-01', passenger_train.number)
    assert_equal([], passenger_train.carriages)
    assert_equal(nil, passenger_train.current_route)
    assert_equal(nil, passenger_train.current_station)
  end

  def test_add_passenger_carriage
    passenger_train = PassengerTrain.new('123-01')
    passenger_carriage = PassengerCarriage.new('1', 36)

    assert_equal([], passenger_train.carriages)

    passenger_train.add_carriage(passenger_carriage)

    assert_equal([passenger_carriage], passenger_train.carriages)
  end

  def test_passenger_add_cargo_carriage
    passenger_train = PassengerTrain.new('123-01')
    cargo_carriage = CargoCarriage.new('1', 10_000)

    assert_equal([], passenger_train.carriages)

    passenger_train.add_carriage(cargo_carriage)

    assert_equal([], passenger_train.carriages)
  end
end
