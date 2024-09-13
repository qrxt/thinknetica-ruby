# frozen_string_literal: true

MANUFACTURER = 'manufacturer01'

module Seed
  def seed
    create_objects

    puts "\nОбъекты созданы. Подробнее в #{highlight('display')}.\n\n"
    @page = 'main'
  end

  private

  def create_passenger_carriage
    carriage = PassengerCarriage.new('1', 36)
    carriage.manufacturer = MANUFACTURER
    carriage.occupy_seat

    carriage
  end

  def create_cargo_carriage
    carriage = CargoCarriage.new('1', 10_000)
    carriage.manufacturer = MANUFACTURER
    carriage.fill(7_500)

    carriage
  end

  def create_passenger_train(carriage)
    train = PassengerTrain.new('123-01')
    train.manufacturer = MANUFACTURER
    train.add_carriage(carriage)

    train
  end

  def create_cargo_train(carriage)
    train = CargoTrain.new('123-02')
    train.manufacturer = MANUFACTURER
    train.add_carriage(carriage)

    train
  end

  def create_seed_route(stations, trains)
    station_a, station_b, station_c = stations

    route = Route.new('A-C', station_a, station_c)
    route.add_intermidiate_station(station_b)

    trains.each { |train| train.assign_route(route) }

    route
  end

  def create_stations
    [Station.new('A'), Station.new('B'), Station.new('C')]
  end

  def create_objects
    stations = create_stations

    passenger_carriage = create_passenger_carriage
    cargo_carriage = create_cargo_carriage

    passenger_train = create_passenger_train(passenger_carriage)
    cargo_train = create_cargo_train(cargo_carriage)

    route = create_seed_route(stations, [passenger_train, cargo_train])

    @stations = stations
    @trains = [passenger_train, cargo_train]
    @routes = [route]
  end
end
