require "test/unit"
require_relative "train"
require_relative "station"
require_relative "route"

class TestTrain < Test::Unit::TestCase
  # Имеет номер (произвольная строка) и тип (грузовой, пассажирский) и количество вагонов,
  # эти данные указываются при создании экземпляра класса
  def test_initial()
    passenger_train = Train.new("001", :passenger, 5)
    freight_train = Train.new("002", :freight, 9)

    assert_equal("001", passenger_train.number)
    assert_equal(:passenger, passenger_train.type)
    assert_equal(5, passenger_train.number_of_carriages)
    assert_equal(nil, passenger_train.current_route)
    assert_equal(nil, passenger_train.current_station)

    assert_equal("002", freight_train.number)
    assert_equal(:freight, freight_train.type)
    assert_equal(9, freight_train.number_of_carriages)
    assert_equal(nil, freight_train.current_route)
    assert_equal(nil, freight_train.current_station)
  end

  # Может набирать скорость
  # Может возвращать текущую скорость
  # Может тормозить (сбрасывать скорость до нуля)
  def test_set_speed()
    train = Train.new("001", :passenger, 9)

    assert_equal(0, train.speed)

    train.speed = 100

    assert_equal(100, train.speed)

    train.stop

    assert_equal(0, train.speed)
  end

  # Может возвращать количество вагонов
  # Может прицеплять/отцеплять вагоны (по одному вагону за операцию, метод просто увеличивает или уменьшает количество вагонов).
  # Прицепка/отцепка вагонов может осуществляться только если поезд не движется.
  def test_carriages()
    train = Train.new("001", :passenger, 5)

    train.add_carriage()

    assert_equal(0, train.speed)

    assert_equal(6, train.number_of_carriages)

    train.remove_carriage()

    assert_equal(5, train.number_of_carriages)

    train.speed = 60

    # Невозможно отцепить вагоны поезда на ходу

    train.remove_carriage()
    train.remove_carriage()

    assert_equal(5, train.number_of_carriages)

    # Невозможно прицепить вагоны на ходу

    train.add_carriage()
    train.add_carriage()

    assert_equal(5, train.number_of_carriages)
  end

  # Может принимать маршрут следования (объект класса Route).
  # При назначении маршрута поезду, поезд автоматически помещается на первую станцию в маршруте.
  def test_route_default_station()
    train = Train.new("001", :passenger, 5)
    route = Route.new("A-C", Station.new("A"), Station.new("C"))

    train.assign_route(route)

    assert_equal("A-C", train.current_route.name)
    assert_equal("A", train.current_station.name)
  end

  # Может перемещаться между станциями, указанными в маршруте. Перемещение возможно вперед и назад, но только на 1 станцию за раз.
  # Возвращать предыдущую станцию, текущую, следующую, на основе маршрута
  def test_move_with_intermidiate()
    train = Train.new("001", :passenger, 5)

    route = Route.new("A-C", Station.new("A"), Station.new("C"))
    route.add_intermidiate_station(Station.new("B"))

    train.assign_route(route)

    assert_equal("A", train.previous_station.name)
    assert_equal("A", train.current_station.name)
    assert_equal("B", train.next_station.name)

    train.move_forward

    assert_equal("A", train.previous_station.name)
    assert_equal("B", train.current_station.name)
    assert_equal("C", train.next_station.name)

    train.move_forward

    assert_equal("B", train.previous_station.name)
    assert_equal("C", train.current_station.name)
    assert_equal("C", train.next_station.name)

    train.move_backward

    assert_equal("A", train.previous_station.name)
    assert_equal("B", train.current_station.name)
    assert_equal("C", train.next_station.name)

    train.move_backward

    assert_equal("A", train.previous_station.name)
    assert_equal("A", train.current_station.name)
    assert_equal("B", train.next_station.name)
  end

  def test_move_without_intermidiate()
    train = Train.new("001", :passenger, 5)
    route = Route.new("A-C", Station.new("A"), Station.new("C"))

    train.assign_route(route)

    assert_equal("A", train.previous_station.name)
    assert_equal("A", train.current_station.name)
    assert_equal("C", train.next_station.name)

    train.move_backward

    assert_equal("A", train.previous_station.name)
    assert_equal("A", train.current_station.name)
    assert_equal("C", train.next_station.name)

    train.move_forward
    train.move_forward

    assert_equal("A", train.previous_station.name)
    assert_equal("C", train.current_station.name)
    assert_equal("C", train.next_station.name)
  end

  def test_move_backward_on_departure_station()
    train = Train.new("001", :passenger, 5)

    route = Route.new("A-C", Station.new("A"), Station.new("C"))

    train.assign_route(route)

    train.move_backward

    assert_equal("A", train.previous_station.name)
    assert_equal("A", train.current_station.name)
    assert_equal("C", train.next_station.name)
  end

  def test_move_forward_on_arrival_station()
    train = Train.new("001", :passenger, 5)

    route = Route.new("A-C", Station.new("A"), Station.new("C"))
    route.add_intermidiate_station(Station.new("B"))
    train.assign_route(route)

    train.move_forward # B
    train.move_forward # C
    train.move_forward

    assert_equal("B", train.previous_station.name)
    assert_equal("C", train.current_station.name)
    assert_equal("C", train.next_station.name)
  end
end
