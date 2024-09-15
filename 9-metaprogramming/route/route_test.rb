# frozen_string_literal: true

require 'test/unit'
require_relative '../station/station'
require_relative 'route'

class TestRoute < Test::Unit::TestCase
  # Имеет начальную и конечную станцию, а также список промежуточных станций.
  # Начальная и конечная станции указываютсся при создании маршрута,
  # а промежуточные могут добавляться между ними.
  def test_ininitial
    departure_station = Station.new('A')
    arrival_station = Station.new('B')

    route = Route.new('A-C', departure_station, arrival_station)

    assert_equal('A-C', route.name)
    assert_equal(departure_station, route.departure_station)
    assert_equal(arrival_station, route.arrival_station)
    assert_equal([departure_station, arrival_station], route.stations)
    assert_equal([], route.intermidiate_stations)
  end

  # Может добавлять промежуточную станцию в список
  # Может удалять промежуточную станцию из списка
  # Может выводить список всех станций по-порядку от начальной до конечной
  def test_intermidiate
    departure_station = Station.new('A')
    intermidiate_station = Station.new('B')
    arrival_station = Station.new('С')

    route = Route.new('A-С', departure_station, arrival_station)

    route.add_intermidiate_station(intermidiate_station)

    assert_equal([departure_station, intermidiate_station, arrival_station], route.stations)

    route.remove_intermidiate_station('B')

    assert_equal([departure_station, arrival_station], route.stations)
  end

  def test_route_validate_name
    assert_raise RuntimeError do
      Route.new(nil, nil, nil)
    end
  end

  def test_route_validate_no_departure_station
    assert_raise RuntimeError do
      Route.new('A-B', nil, Station.new('A'))
    end
  end

  def test_route_validate_no_arrival_station
    assert_raise RuntimeError do
      Route.new('A-B', Station.new('A'), nil)
    end
  end

  def test_route_validate_stations_type
    assert_raise RuntimeError do
      Route.new('A-B', '', '')
    end
  end

  def test_route_validate_same_station
    assert_raise RuntimeError do
      station = Station.new('A')
      Route.new('A-B', station, station)
    end
  end
end
