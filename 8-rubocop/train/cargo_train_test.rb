# frozen_string_literal: true

require 'test/unit'

require_relative 'cargo_train'
require_relative '../carriage/passenger_carriage'
require_relative '../carriage/cargo_carriage'

class TestTrain < Test::Unit::TestCase
  def test_cargo_train_initial
    cargo_train = CargoTrain.new('123-02')

    assert_equal('123-02', cargo_train.number)
    assert_equal([], cargo_train.carriages)
    assert_equal(nil, cargo_train.current_route)
    assert_equal(nil, cargo_train.current_station)
  end

  def test_cargo_add_cargo_carriage
    cargo_train = CargoTrain.new('123-01')
    cargo_carriage = CargoCarriage.new('1', 10_000)

    assert_equal([], cargo_train.carriages)

    cargo_train.add_carriage(cargo_carriage)

    assert_equal([cargo_carriage], cargo_train.carriages)
  end

  def test_cant_add_passenger_carriage
    cargo_train = CargoTrain.new('123-01')
    passenger_carriage = PassengerCarriage.new('1', 36)

    assert_equal([], cargo_train.carriages)

    cargo_train.add_carriage(passenger_carriage)

    assert_equal([], cargo_train.carriages)
  end
end
