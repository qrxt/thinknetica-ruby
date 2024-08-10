# frozen_string_literal: true

require_relative 'utils/highlight'
require_relative 'carriage/carriage'
require_relative 'train/passenger_train'
require_relative 'train/cargo_train'
require_relative 'station/station'
require_relative 'route/route'

MENU_MAIN = {
  create: 'создать объект',
  manage: 'произвести операции над объектами',
  display: 'вывести данные об объектах',
  seed: 'сгенерировать начальный набор объектов',
  stop: 'завершить выполнение программы'
}.freeze

MENU_CREATE = {
  train: 'создать поезд',
  station: 'создать станцию',
  route: 'создать маршрут',
  main: 'вернуться на главную'
}.freeze

MENU_DISPLAY = {
  trains: 'вывести список поездов',
  stations: 'вывести список станция',
  routes: 'вывести список маршрутов',
  main: 'вернуться на главную'
}.freeze

MENU_MANAGE = {
  add_carriage: 'прицепить вагон к поезду',
  remove_carriage: 'отцепить вагон от поезда',
  add_intermidiate_station: 'добавить маршруту дополнительную станцию',
  assign_route: 'назначить поезду маршрут',
  move_train: 'отправить поезд на следующую или предыдущую станцию',
  main: 'вернуться на главную'
}.freeze

class Railroad
  include Highlight

  attr_reader :trains, :stations, :routes

  def initialize
    @is_running = true
    @page = 'main'

    @trains = []
    @stations = []
    @routes = []
  end

  def menu
    while @is_running
      break if @page == 'stop'

      case @page
      when 'main' then main
      when 'stop' then stop

      when 'seed' then seed

      when 'display' then display
      when 'display_trains' then display_trains
      when 'display_stations' then display_stations
      when 'display_routes' then display_routes

      when 'create' then create
      when 'create_train' then create_train
      when 'create_station' then create_station
      when 'create_route' then create_route

      when 'manage' then manage
      when 'manage_add_carriage' then manage_add_carriage
      when 'manage_remove_carriage' then manage_remove_carriage
      when 'manage_add_intermidiate_station' then manage_add_intermidiate_station
      when 'manage_assign_route' then manage_assign_route
      when 'manage_move_train' then manage_move_train

      else not_found

      end
    end
  end

  private

  # методы ниже не предназначены для вызова снаружи, подразумевается,
  # что все нужные действия можно выполнить через rr.menu

  attr_writer :trains, :stations, :routes

  def seed
    station_a = Station.new('A')
    station_b = Station.new('B')
    station_c = Station.new('C')

    passenger_carriage = PassengerCarriage.new('1')
    cargo_carriage = CargoCarriage.new('1')

    passenger_train = PassengerTrain.new('1')
    cargo_train = CargoTrain.new('2')

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

  def stop
    @is_running = false
  end

  def print_menu(menu)
    menu.each do |item, description|
      puts "Введите #{highlight(item)}, если нужно #{description}"
    end
  end

  def not_found
    puts "Страница #{highlight(@page)} не найдена. Убедитесь в корректности написания."
    @page = gets.chomp
  end

  def main
    MENU_MAIN.each do |item, description|
      puts "Введите #{highlight(item)}, если нужно #{description}"
    end

    @page = gets.chomp
  end

  def create_subpages
    %w[train station route]
  end

  def create
    print_menu(MENU_CREATE)

    input = gets.chomp
    @page = create_subpages.include?(input) ? "create_#{input}" : 'main'
  end

  def create_train
    puts 'Создание поезда'

    puts "Введите тип поезда (#{highlight('passenger')} или #{highlight('cargo')})"

    type = gets.chomp

    return unless %w[passenger cargo].include?(type)

    puts 'Введите номер поезда (строка):'

    number = gets.chomp

    train = type == 'passenger' ? PassengerTrain.new(number) : CargoTrain.new(number)

    @trains << train

    puts "\nСоздан поезд: #{train.info}\n\n"

    @page = 'create'
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

  def display_subpages
    %w[trains stations routes]
  end

  def display
    print_menu(MENU_DISPLAY)

    input = gets.chomp
    @page = display_subpages.include?(input) ? "display_#{input}" : 'main'
  end

  def display_trains
    puts "Список поездов:\n"

    @trains.each do |train|
      train_carriages = train.carriages.map(&:number).join(', ')
      train_carriages_string = train.carriages.any? ? "(Вагоны: #{train_carriages})" : ''

      train_route_string = if train.current_route
                             "(Маршрут: #{train.current_route.info}, текущая станция: #{train.current_station.name})"
                           else
                             ''
                           end

      puts "\nПоезд #{train.info} #{train_carriages_string} #{train_route_string}"
    end

    @page = 'display'
  end

  def display_stations
    puts "Список станций:\n"

    @stations.each do |station|
      trains_on_station = station.trains.map(&:number).join(', ')
      trains_on_station_string = station.trains.any? ? "(Поезда на станции: #{trains_on_station})" : ''

      puts "\nСтанция #{station.name} #{trains_on_station_string}\n"
    end

    @page = 'display'
  end

  def display_routes
    puts "Список маршрутов:\n"

    @routes.each do |route|
      puts "Маршрут #{route.name} (#{route.info})"
    end

    @page = 'display'
  end

  def manage_subpages
    %w[
      add_carriage
      remove_carriage
      add_intermidiate_station
      assign_route
      move_train
    ]
  end

  def manage
    print_menu(MENU_MANAGE)

    input = gets.chomp
    @page = manage_subpages.include?(input) ? "manage_#{input}" : 'main'
  end

  def manage_add_carriage
    puts 'Прицепка вагона'

    puts "Сейчас доступны следующие поезда: #{@trains.map(&:number).join(', ')}"

    puts 'Введите номер поезда для прицепки вагона:'

    train = prompt_for_train

    return unless train

    puts 'Введите номер вагона:'

    carriage_number = gets.chomp

    carriage = train.is_a?(PassengerTrain) ? PassengerCarriage.new(carriage_number) : CargoCarriage.new(carriage_number)

    train.add_carriage(carriage)

    puts "\nВагон #{carriage.number} прицеплен к поезду #{train.number}\n\n"

    @page = 'manage'
  end

  def manage_remove_carriage
    puts 'Отцепка вагона'

    puts "Сейчас доступны следующие поезда: #{@trains.map(&:number).join(', ')}"

    puts 'Введите номер поезда для отцепки вагона:'

    train = prompt_for_train

    return unless train

    carriages_string = train.carriages.map(&:number).join(', ')

    puts "Для поезда #{train.number} доступны вагоны: #{carriages_string}"

    puts 'Введите номер вагона'

    carriage_number = gets.chomp

    train.remove_carriage(carriage_number)

    puts 'Вагон отцеплен'

    @page = 'manage'
  end

  def manage_add_intermidiate_station
    puts 'Добавление промежуточной станции'

    puts "Сейчас доступны следующие маршруты: #{@routes.map(&:name).join(', ')}"

    puts 'Введите название маршрута для добавление промежуточной станции:'

    route = prompt_for_route

    return unless route

    fitting_stations = @stations.reject { |station| route.station?(station.name) }

    puts "Сейчас доступны следующие станции: #{fitting_stations.map(&:name).join(', ')}"

    station = prompt_for_station

    return unless station

    route.add_intermidiate_station(station)

    @page = 'manage'
  end

  def manage_assign_route
    puts 'Назначение маршрута'

    fitting_trains = @trains.reject(&:current_route)

    puts "Сейчас доступны следующие поезда: #{fitting_trains.map(&:number).join(', ')}"

    train = prompt_for_train

    return unless train

    puts "Сейчас доступны следующие маршруты: #{@routes.map(&:name).join(', ')}"

    puts 'Введите название маршрута:'

    route = prompt_for_route

    return unless route

    train.assign_route(route)

    puts "Маршрут #{route.name} назначен для поезда #{train.number}"

    @page = 'manage'
  end

  def manage_move_train
    puts 'Передвижение поезда'

    puts "Сейчас доступны следующие поезда: #{@trains.map(&:number).join(', ')}"

    puts 'Введите номер поезда для прицепки вагона:'

    train = prompt_for_train

    return unless train

    puts "Введите #{highlight('forward')} или #{highlight('backward')}, чтобы отправить поезд в нужном направлении"

    direction = gets.chomp

    previous_station = train.previous_station

    direction == 'backward' ? train.go_previous_station : train.go_next_station

    puts "Поезд передвинулся со станции #{previous_station.name} на станцию #{train.current_station.name}"

    @page = 'manage'
  end

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

  attr_accessor :page, :is_running
end
