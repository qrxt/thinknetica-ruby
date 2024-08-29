# frozen_string_literal: true

require_relative '../utils/prompt'
require_relative '../../utils/highlight'

MENU_CREATE = {
  train: 'создать поезд',
  station: 'создать станцию',
  route: 'создать маршрут',
  main: 'вернуться на главную'
}.freeze

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
      puts 'Создание поезда'

      puts "Введите тип поезда (#{highlight('passenger')} или #{highlight('cargo')})"

      type = gets.chomp

      return unless %w[passenger cargo].include?(type)

      puts 'Введите номер поезда (строка):'

      number = gets.chomp

      train = type == 'passenger' ? PassengerTrain.new(number) : CargoTrain.new(number)

      train.manufacturer = prompt_for_manufacturer

      @trains << train

      puts "\nСоздан поезд: #{train.info}\n\n"

      @page = 'create'
    rescue RuntimeError => e
      attempt_counter += 1

      puts "Введены некорректные данные (попытка №#{attempt_counter}): #{e}"

      attempt_counter < 3 ? retry : raise
    end
  end

  def create_station
    puts 'Создание станции'

    puts 'Введите название станции:'

    name = gets.chomp

    station = Station.new(name)

    @stations << station

    puts "\nСоздана станция: #{station.name}\n\n"

    @page = 'create'
  end

  def create_route
    puts 'Создание маршрута'

    puts "Сейчас доступны следующие станции: #{@stations.map(&:name).join(', ')}"

    puts 'Введите название начальной станции:'

    departure_station_name = gets.chomp

    puts 'Введите название конечной станции:'

    arrival_station_name = gets.chomp

    departure_station = @stations.find { |station| station.name == departure_station_name }
    arrival_station = @stations.find { |station| station.name == arrival_station_name }

    if !departure_station || !arrival_station
      puts 'Начальная или конечная станция не найдена'

      @page = 'create'

      return
    end

    route = Route.new("#{departure_station_name}-#{arrival_station_name}", departure_station, arrival_station)

    @routes << route

    puts "\nСоздан маршрут: #{route.name}\n"
    puts "Промежуточные станции можно добавить через #{highlight('manage')}\n\n"

    @page = 'create'
  end
end
