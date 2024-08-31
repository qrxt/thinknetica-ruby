# frozen_string_literal: true

module Prompt
  def prompt_for_train
    train_number = gets.chomp

    train = @trains.find { |current_train| current_train.number == train_number }

    unless train
      puts 'Поезд с таким номером не найден'

      @page = 'manage'

      return nil
    end

    train
  end

  def prompt_for_route
    route_name = gets.chomp

    route = @routes.find { |current_route| current_route.name == route_name }

    unless route
      puts 'Маршрут с таким названием не найден'

      @page = 'manage'

      return nil
    end

    route
  end

  def prompt_for_station
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
end
