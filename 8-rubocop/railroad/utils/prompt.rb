# frozen_string_literal: true

module Prompt
  def prompt_for_train(trains = @trains)
    puts "Сейчас доступны следующие поезда: #{trains.map(&:number).join(', ')}"

    train_number = gets.chomp

    train = @trains.find { |current_train| current_train.number == train_number }

    unless train
      puts 'Поезд с таким номером не найден'

      @page = 'manage'

      return nil
    end

    train
  end

  def prompt_for_route(routes = @routes)
    puts "Сейчас доступны следующие маршруты: #{routes.map(&:name).join(', ')}"

    route_name = gets.chomp

    route = @routes.find { |current_route| current_route.name == route_name }

    unless route
      puts 'Маршрут с таким названием не найден'

      @page = 'manage'

      return nil
    end

    route
  end

  def prompt_for_station(stations = @stations)
    puts "Сейчас доступны следующие станции: #{stations.map(&:name).join(', ')}"

    station_name = gets.chomp

    station = @stations.find { |current_station| current_station.name == station_name }

    unless station
      puts 'Станция с таким названием не найдена'

      @page = 'manage'

      return nil
    end

    station
  end

  def prompt_for_manufacturer
    puts 'Введите название производителя:'

    gets.chomp
  end

  def prompt_for_seats
    puts 'Введите количество посадочных мест вагона:'

    gets.chomp.to_i
  end

  def prompt_for_volume
    puts 'Введите объем вагона:'

    gets.chomp.to_i
  end

  def prompt_for_volume_fill(carriage)
    puts "Введите занимаемый объем для добавления груза (сейчас #{carriage.occupied_volume} / #{carriage.volume}):"

    gets.chomp.to_i
  end

  def prompt_for_carriage(carriages)
    puts "У этого поезда есть следующие вагоны: #{carriages.map(&:number).join(', ')}"

    carriage_number = gets.chomp

    carriage = carriages.find { |current_carriage| current_carriage.number == carriage_number }

    unless carriage
      puts 'Вагон с таким номером не найден'

      @page = 'manage'

      return nil
    end

    carriage
  end

  def prompt_for_direction
    puts "Введите #{highlight('forward')} или #{highlight('backward')}, чтобы отправить поезд в нужном направлении"

    gets.chomp
  end

  def prompt_for_carriage_number(carriages)
    carriages_string = carriages.map(&:number).join(', ')

    puts "Уже существуют следующие вагоны: #{carriages_string}"

    puts 'Введите номер вагона:'

    gets.chomp
  end

  def prompt_for_train_type
    puts "Введите тип поезда (#{highlight('passenger')} или #{highlight('cargo')})"

    gets.chomp
  end

  def prompt_for_train_number
    puts 'Введите номер поезда (строка):'

    gets.chomp
  end

  def prompt_for_departure_station
    puts 'Введите название начальной станции:'

    prompt_for_station
  end

  def prompt_for_arrival_station
    puts 'Введите название конечной станции:'

    prompt_for_station
  end
end
