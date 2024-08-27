# frozen_string_literal: true

require 'test/unit'

require_relative 'passenger_train'
require_relative '../carriage/passenger_carriage'
require_relative '../carriage/cargo_carriage'

class TestTrain < Test::Unit::TestCase
  def test_initial
    passenger_train = PassengerTrain.new('001')

    assert_equal('001', passenger_train.number)
  end

  def test_train_add_passenger_carriage
    passenger_train = PassengerTrain.new('001')
    passenger_carriage = PassengerCarriage.new('1')

    assert_equal([], passenger_train.carriages)

    passenger_train.add_carriage(passenger_carriage)

    assert_equal([passenger_carriage], passenger_train.carriages)
  end

  def test_train_add_cargo_carriage
    passenger_train = PassengerTrain.new('001')
    cargo_carriage = CargoCarriage.new('1')

    assert_equal([], passenger_train.carriages)

    passenger_train.add_carriage(cargo_carriage)

    assert_equal([], passenger_train.carriages)
  end
end
