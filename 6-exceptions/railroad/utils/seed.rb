# frozen_string_literal: true

module Seed
  def seed
    manufacturer = 'manufacturer01'

    station_a = Station.new('A')
    station_b = Station.new('B')
    station_c = Station.new('C')

    passenger_carriage = PassengerCarriage.new('1')
    passenger_carriage.manufacturer = manufacturer

    cargo_carriage = CargoCarriage.new('1')
    cargo_carriage.manufacturer = manufacturer

    passenger_train = PassengerTrain.new('1')
    passenger_train.manufacturer = manufacturer

    cargo_train = CargoTrain.new('2')
    cargo_train.manufacturer = manufacturer

    passenger_train.add_carriage(passenger_carriage)
    cargo_train.add_carriage(cargo_carriage)

    route = Route.new('A-C', station_a, station_c)
    route.add_intermidiate_station(station_b)

    passenger_train.assign_route(route)
    cargo_train.assign_route(route)

    @stations = [station_a, station_b, station_c]
    @trains = [passenger_train, cargo_train]
    @routes = [route]

    puts "\nОбъекты созданы. Подробнее в #{highlight('display')}.\n\n"
    @page = 'main'
  end
end
