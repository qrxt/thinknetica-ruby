# frozen_string_literal: true

require 'test/unit'
require_relative '../station/station'
require_relative '../route/route'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative '../carriage/passenger_carriage'

class TestRouteTrain < Test::Unit::TestCase
  # Может принимать маршрут следования (объект класса Route).
  # При назначении маршрута поезду, поезд автоматически помещается на первую станцию в маршруте.
  def test_route_default_station
    train = PassengerTrain.new('123-01')
    route = Route.new('A-C', Station.new('A'), Station.new('C'))

    train.assign_route(route)

    assert_equal('A-C', train.current_route.name)
    assert_equal('A', train.current_station.name)
  end

  # Может перемещаться между станциями, указанными в маршруте.
  # Перемещение возможно вперед и назад, но только на 1 станцию за раз.
  def test_move_with_intermidiate_forward
    train = PassengerTrain.new('123-01')

    route = Route.new('A-C', Station.new('A'), Station.new('C'))
    route.add_intermidiate_station(Station.new('B'))

    train.assign_route(route)

    assert_equal('A', train.current_station.name)

    assert_equal('B', train.go_next_station.name)

    assert_equal('C', train.go_next_station.name)
  end

  def test_move_with_intermidiate_backward
    train = PassengerTrain.new('123-01')

    route = Route.new('A-C', Station.new('A'), Station.new('C'))
    route.add_intermidiate_station(Station.new('B'))

    train.assign_route(route)

    train.go_next_station
    train.go_next_station

    assert_equal('B', train.go_previous_station.name)

    assert_equal('A', train.go_previous_station.name)
  end

  def test_move_without_intermidiate_initial
    train = PassengerTrain.new('123-01')
    route = Route.new('A-C', Station.new('A'), Station.new('C'))

    train.assign_route(route)

    assert_equal('A', train.previous_station.name)
    assert_equal('A', train.current_station.name)
    assert_equal('C', train.next_station.name)
  end

  def test_move_without_intermidiate_previous
    train = PassengerTrain.new('123-01')
    route = Route.new('A-C', Station.new('A'), Station.new('C'))

    train.assign_route(route)

    train.go_previous_station

    assert_equal('A', train.previous_station.name)
    assert_equal('A', train.current_station.name)
    assert_equal('C', train.next_station.name)
  end

  def test_move_without_intermidiate_next
    train = PassengerTrain.new('123-01')
    route = Route.new('A-C', Station.new('A'), Station.new('C'))

    train.assign_route(route)

    train.go_next_station
    train.go_next_station

    assert_equal('A', train.previous_station.name)
    assert_equal('C', train.current_station.name)
    assert_equal('C', train.next_station.name)
  end

  def test_move_backward_on_departure_station
    train = PassengerTrain.new('123-01')

    route = Route.new('A-C', Station.new('A'), Station.new('C'))

    train.assign_route(route)

    train.go_previous_station

    assert_equal('A', train.previous_station.name)
    assert_equal('A', train.current_station.name)
    assert_equal('C', train.next_station.name)
  end

  def test_move_forward_on_arrival_station
    train = PassengerTrain.new('123-01')

    route = Route.new('A-C', Station.new('A'), Station.new('C'))
    route.add_intermidiate_station(Station.new('B'))
    train.assign_route(route)

    train.go_next_station # B
    train.go_next_station # C
    train.go_next_station

    assert_equal('C', train.current_station.name)
  end
end
