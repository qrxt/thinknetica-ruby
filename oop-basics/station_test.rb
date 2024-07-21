require "test/unit"
require_relative "train"
require_relative "station"
require_relative "route"

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

    passenger_train = Train.new("001", :passenger, 5)
    freight_train = Train.new("002", :freight, 9)

    assert_equal([], station.trains)

    station.add_train(passenger_train)
    station.add_train(freight_train)

    assert_equal([passenger_train, freight_train], station.trains)
  end

  # Может возвращать список поездов на станции по типу (см. ниже): кол-во грузовых, пассажирских
  def test_get_train_types()
    station = Station.new('A')

    passenger_train = Train.new("001", :passenger, 5)
    freight_train = Train.new("002", :freight, 9)

    station.add_train(passenger_train)
    station.add_train(freight_train)

    expected = {
      :freight => [freight_train],
      :passenger => [passenger_train]
    }

    assert_equal(expected, station.get_train_types())
  end

  # Может отправлять поезда (по одному за раз, при этом, поезд удаляется из списка поездов, находящихся на станции).
  def test_send()
    departure_station = Station.new("A")
    arrival_station = Station.new("B")

    train = Train.new("001", :passenger, 5)
    route = Route.new("A-B", departure_station, arrival_station)

    train.assign_route(route)

    assert_equal([train], departure_station.trains)

    departure_station.send("001")

    assert_equal([], departure_station.trains)

    assert_equal([train], arrival_station.trains)
  end
end
