# frozen_string_literal: true

require 'test/unit'
require_relative '../train/passenger_train'
require_relative '../train/cargo_train'
require_relative '../route/route'
require_relative 'station'

class TestStation < Test::Unit::TestCase
  # Имеет название, которое указывается при ее создании
  def test_station_initial
    station = Station.new('A')

    assert_equal('A', station.name)
    assert_equal([], station.trains)
  end

  # Может принимать поезда (по одному за раз)
  # Может возвращать список всех поездов на станции, находящиеся в текущий момент
  def test_add_train
    station = Station.new('A')

    passenger_train = PassengerTrain.new('123-01')
    cargo_train = CargoTrain.new('123-02')

    assert_equal([], station.trains)

    station.add_train(passenger_train)
    station.add_train(cargo_train)

    assert_equal([passenger_train, cargo_train], station.trains)
  end

  # Может возвращать список поездов на станции по типу (см. ниже): кол-во грузовых, пассажирских
  def test_train_types
    station = Station.new('A')

    passenger_train = PassengerTrain.new('123-01')
    cargo_train = CargoTrain.new('123-02')

    station.add_train(passenger_train)
    station.add_train(cargo_train)

    expected = {
      CargoTrain => [cargo_train],
      PassengerTrain => [passenger_train]
    }

    assert_equal(expected, station.train_types)
  end

  # Может отправлять поезда (по одному за раз, при этом, поезд удаляется из списка поездов, находящихся на станции).
  def test_send
    departure_station = Station.new('A')
    arrival_station = Station.new('B')

    train = PassengerTrain.new('123-01')
    route = Route.new('A-B', departure_station, arrival_station)

    train.assign_route(route)

    assert_equal([train], departure_station.trains)

    departure_station.send('123-01')

    assert_equal([], departure_station.trains)

    assert_equal([train], arrival_station.trains)
  end

  def test_station_validate_name
    assert_raise ArgumentError do
      Station.new(nil)
    end
  end

  def test_station_validate_name_len
    assert_raise ArgumentError do
      Station.new('')
    end
  end

  def test_station_each_train
    station = Station.new('A')

    passenger_train = PassengerTrain.new('123-01')
    cargo_train = CargoTrain.new('123-02')

    station.add_train(passenger_train)
    station.add_train(cargo_train)

    expected = [passenger_train, cargo_train]
    current = []

    station.each_train { |train| current << train }

    assert_equal(expected, current)
  end
end
