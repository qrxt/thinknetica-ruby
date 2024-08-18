# frozen_string_literal: true

require 'test/unit'

require_relative 'cargo_train'
require_relative '../carriage/passenger_carriage'
require_relative '../carriage/cargo_carriage'

class TestTrain < Test::Unit::TestCase
  def test_initial
    cargo_train = CargoTrain.new('001')

    assert_equal('001', cargo_train.number)
  end

  def test_add_cargo_carriage
    cargo_train = CargoTrain.new('001')
    cargo_carriage = CargoCarriage.new('1')

    assert_equal([], cargo_train.carriages)

    cargo_train.add_carriage(cargo_carriage)

    assert_equal([cargo_carriage], cargo_train.carriages)
  end

  def test_add_passenger_carriage
    cargo_train = CargoTrain.new('001')
    passenger_carriage = PassengerCarriage.new('1')

    assert_equal([], cargo_train.carriages)

    cargo_train.add_carriage(passenger_carriage)

    assert_equal([], cargo_train.carriages)
  end
end
