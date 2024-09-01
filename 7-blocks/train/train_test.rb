# frozen_string_literal: true

require 'test/unit'
require_relative '../station/station'
require_relative '../route/route'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative '../carriage/passenger_carriage'

class TestTrain < Test::Unit::TestCase
  # Имеет номер (произвольная строка) и тип (грузовой, пассажирский) и количество вагонов,
  # эти данные указываются при создании экземпляра класса
  def test_train_initial
    passenger_train = PassengerTrain.new('123-01')
    cargo_train = CargoTrain.new('123-02')

    assert_equal('123-01', passenger_train.number)
    assert_equal([], passenger_train.carriages)
    assert_equal(nil, passenger_train.current_route)
    assert_equal(nil, passenger_train.current_station)

    assert_equal('123-02', cargo_train.number)
    assert_equal([], cargo_train.carriages)
    assert_equal(nil, cargo_train.current_route)
    assert_equal(nil, cargo_train.current_station)
  end

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

  # Может возвращать количество вагонов
  # Может прицеплять/отцеплять вагоны
  # Прицепка/отцепка вагонов может осуществляться только если поезд не движется.
  def test_carriages
    train = PassengerTrain.new('123-01')
    carriage = PassengerCarriage.new('1', 36)

    train.add_carriage(carriage)

    assert_equal(0, train.speed)

    assert_equal([carriage], train.carriages)

    train.remove_carriage('1')

    assert_equal([], train.carriages)

    # Невозможно отцепить вагоны поезда на ходу

    train.add_carriage(carriage)

    train.start

    train.remove_carriage(carriage)

    assert_equal([carriage], train.carriages)

    # Невозможно прицепить вагоны на ходу

    train.add_carriage(PassengerCarriage.new('2', 36))

    assert_equal([carriage], train.carriages)
  end

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
  # Возвращать предыдущую станцию, текущую, следующую, на основе маршрута.
  def test_move_with_intermidiate
    train = PassengerTrain.new('123-01')

    route = Route.new('A-C', Station.new('A'), Station.new('C'))
    route.add_intermidiate_station(Station.new('B'))

    train.assign_route(route)

    assert_equal('A', train.previous_station.name)
    assert_equal('A', train.current_station.name)
    assert_equal('B', train.next_station.name)

    train.go_next_station

    assert_equal('A', train.previous_station.name)
    assert_equal('B', train.current_station.name)
    assert_equal('C', train.next_station.name)

    train.go_next_station

    assert_equal('B', train.previous_station.name)
    assert_equal('C', train.current_station.name)
    assert_equal('C', train.next_station.name)

    train.go_previous_station

    assert_equal('A', train.previous_station.name)
    assert_equal('B', train.current_station.name)
    assert_equal('C', train.next_station.name)

    train.go_previous_station

    assert_equal('A', train.previous_station.name)
    assert_equal('A', train.current_station.name)
    assert_equal('B', train.next_station.name)
  end

  def test_move_without_intermidiate
    train = PassengerTrain.new('123-01')
    route = Route.new('A-C', Station.new('A'), Station.new('C'))

    train.assign_route(route)

    assert_equal('A', train.previous_station.name)
    assert_equal('A', train.current_station.name)
    assert_equal('C', train.next_station.name)

    train.go_previous_station

    assert_equal('A', train.previous_station.name)
    assert_equal('A', train.current_station.name)
    assert_equal('C', train.next_station.name)

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

    assert_equal('B', train.previous_station.name)
    assert_equal('C', train.current_station.name)
    assert_equal('C', train.next_station.name)
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
    assert_raise RuntimeError do
      PassengerTrain.new(nil)
    end
  end

  def test_train_validate_number_len
    assert_raise RuntimeError do
      PassengerTrain.new('')
    end
  end

  def test_train_validate_format
    assert_raise RuntimeError do
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
