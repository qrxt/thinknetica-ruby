# frozen_string_literal: true

require 'test/unit'
require_relative '../station/station'
require_relative '../route/route'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative '../carriage/passenger_carriage'

class TestTrain < Test::Unit::TestCase
  # Может возвращать количество вагонов
  def test_carriages
    train = PassengerTrain.new('123-01')
    carriage = PassengerCarriage.new('1', 36)

    train.add_carriage(carriage)

    assert_equal(0, train.speed)

    assert_equal([carriage], train.carriages)

    train.remove_carriage('1')

    assert_equal([], train.carriages)
  end

  # Может прицеплять/отцеплять вагоны
  # Прицепка/отцепка вагонов может осуществляться только если поезд не движется.
  def test_carriages_on_move
    train = PassengerTrain.new('123-01')
    carriage = PassengerCarriage.new('1', 36)

    # Невозможно отцепить вагоны поезда на ходу

    train.add_carriage(carriage)

    train.start

    train.remove_carriage(carriage)

    assert_equal([carriage], train.carriages)

    # Невозможно прицепить вагоны на ходу

    train.add_carriage(PassengerCarriage.new('2', 36))

    assert_equal([carriage], train.carriages)
  end
end
