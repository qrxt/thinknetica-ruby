require "test/unit"
require_relative "../train/passenger_train"
require_relative "../train/cargo_train"
require_relative "../route/route"
require_relative "station"

class TestStation < Test::Unit::TestCase
  # Имеет название, которое указывается при ее создании
  def test_initial()
    station = Station.new('A')

    assert_equal("A", station.name)
    assert_equal([], station.trains)
  end

  # Может принимать поезда (по одному за раз)
  # Может возвращать список всех поездов на станции, находящиеся в текущий момент
  def test_add_train()
    station = Station.new('A')

    passenger_train = PassengerTrain.new("001")
    cargo_train = CargoTrain.new("002")

    assert_equal([], station.trains)

    station.add_train(passenger_train)
    station.add_train(cargo_train)

    assert_equal([passenger_train, cargo_train], station.trains)
  end

  # Может возвращать список поездов на станции по типу (см. ниже): кол-во грузовых, пассажирских
  def test_get_train_types()
    station = Station.new('A')

    passenger_train = PassengerTrain.new("001")
    cargo_train = CargoTrain.new("002")

    station.add_train(passenger_train)
    station.add_train(cargo_train)

    expected = {
      CargoTrain => [cargo_train],
      PassengerTrain => [passenger_train]
    }

    assert_equal(expected, station.get_train_types())
  end

  # Может отправлять поезда (по одному за раз, при этом, поезд удаляется из списка поездов, находящихся на станции).
  def test_send()
    departure_station = Station.new("A")
    arrival_station = Station.new("B")

    train = PassengerTrain.new("001")
    route = Route.new("A-B", departure_station, arrival_station)

    train.assign_route(route)

    assert_equal([train], departure_station.trains)

    departure_station.send("001")

    assert_equal([], departure_station.trains)

    assert_equal([train], arrival_station.trains)
  end
end
