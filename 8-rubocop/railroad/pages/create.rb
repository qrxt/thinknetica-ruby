# frozen_string_literal: true

require_relative '../utils/prompt'
require_relative '../../utils/highlight'

MENU_CREATE = {
  train: 'создать поезд',
  station: 'создать станцию',
  route: 'создать маршрут',
  main: 'вернуться на главную'
}.freeze

NOT_ENOUGH_STATIONS_ERROR = 'Недостаточно станций, чтобы создать маршрут'

module PageCreate
  include Prompt
  include Highlight

  def create_subpages
    %w[train station route]
  end

  def create
    print_menu(MENU_CREATE)

    input = gets.chomp
    @page = create_subpages.include?(input) ? "create_#{input}" : 'main'
  end

  def create_train
    attempt_counter = 0

    begin
      prompt_for_train_creation
    rescue RuntimeError => e
      attempt_counter += 1

      puts "Введены некорректные данные (попытка №#{attempt_counter}): #{e}"

      attempt_counter < 3 ? retry : raise
    end
  end

  def prompt_for_train_creation
    puts 'Создание поезда'

    type = prompt_for_train_type

    return unless %w[passenger cargo].include?(type)

    number = prompt_for_train_number

    train = type == 'passenger' ? PassengerTrain.new(number) : CargoTrain.new(number)

    train.manufacturer = prompt_for_manufacturer

    @trains << train

    puts "\nСоздан поезд: #{train.info}\n\n"

    @page = 'create'
  end

  def prompt_for_train_type
    puts "Введите тип поезда (#{highlight('passenger')} или #{highlight('cargo')})"

    gets.chomp
  end

  def prompt_for_train_number
    puts 'Введите номер поезда (строка):'

    gets.chomp
  end

  def create_station
    attempt_counter = 0

    begin
      prompt_for_station_creation
    rescue RuntimeError => e
      attempt_counter += 1

      puts "Введены некорректные данные (попытка №#{attempt_counter}): #{e}"

      attempt_counter < 3 ? retry : raise
    end
  end

  def prompt_for_station_creation
    puts 'Создание станции'

    puts 'Введите название станции:'

    name = gets.chomp

    station = Station.new(name)

    @stations << station

    puts "\nСоздана станция: #{station.name}\n\n"

    @page = 'create'
  end

  def create_route
    attempt_counter = 0

    begin
      prompt_for_route_creation
    rescue RuntimeError => e
      attempt_counter += 1

      puts "Введены некорректные данные (попытка №#{attempt_counter}): #{e}"

      attempt_counter < 3 ? retry : raise
    end
  end

  def prompt_for_route_creation
    puts 'Создание маршрута'

    return if check_no_stations

    departure_station = prompt_for_departure_station
    arrival_station = prompt_for_arrival_station

    route = Route.new("#{departure_station.name}-#{arrival_station.name}", departure_station, arrival_station)

    @routes << route

    puts "\nСоздан маршрут: #{route.name}\n"

    @page = 'create'
  end

  def prompt_for_departure_station
    puts 'Введите название начальной станции:'

    prompt_for_station
  end

  def prompt_for_arrival_station
    puts 'Введите название конечной станции:'

    prompt_for_station
  end

  def check_no_stations
    return if stations.size > 2

    puts NOT_ENOUGH_STATIONS_ERROR

    @page = 'create'
  end
end
