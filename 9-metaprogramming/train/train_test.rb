# frozen_string_literal: true

require 'test/unit'
require_relative '../station/station'
require_relative '../route/route'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative '../carriage/passenger_carriage'

class TestTrain < Test::Unit::TestCase
  # Может набирать скорость
  # Может возвращать текущую скорость
  # Может тормозить (сбрасывать скорость до нуля)
  def test_set_speed
    train = PassengerTrain.new('123-01')

    assert_equal(0, train.speed)

    train.start

    assert_equal(65, train.speed)

    train.stop

    assert_equal(0, train.speed)
  end

  # В классе Train создать метод класса find,
  # который принимает номер поезда (указанный при его создании) и
  def test_train_find
    train1 = PassengerTrain.new('123-91')
    train2 = CargoTrain.new('123-92')

    assert_equal(train1, Train.find('123-91'))
    assert_equal(train2, Train.find('123-92'))
  end

  # Метод класса find возвращает объект поезда по номеру или nil,
  # если поезд с таким номером не найден.
  def test_train_find_nil
    assert_equal(nil, Train.find('123-00'))
  end

  def test_train_validate_number
    assert_raise ArgumentError do
      PassengerTrain.new(nil)
    end
  end

  def test_train_validate_number_len
    assert_raise ArgumentError do
      PassengerTrain.new('')
    end
  end

  def test_train_validate_format
    assert_raise ArgumentError do
      PassengerTrain.new('12-21')
    end
  end

  def test_train_each_carriage
    train = PassengerTrain.new('123-01')
    carriage1 = PassengerCarriage.new('1', 36)
    carriage2 = PassengerCarriage.new('2', 36)

    train.add_carriage(carriage1)
    train.add_carriage(carriage2)

    expected = [carriage1, carriage2]
    current = []

    train.each_carriage { |carriage| current << carriage }

    assert_equal(expected, current)
  end
end
