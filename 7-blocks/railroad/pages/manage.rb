# frozen_string_literal: true

require_relative '../utils/prompt'
require_relative '../../utils/highlight'

MENU_MANAGE = {
  add_carriage: 'прицепить вагон к поезду',
  remove_carriage: 'отцепить вагон от поезда',
  add_intermidiate_station: 'добавить маршруту дополнительную станцию',
  assign_route: 'назначить поезду маршрут',
  move_train: 'отправить поезд на следующую или предыдущую станцию',
  occupy_volume: 'занять объем грузового вагона',
  occupy_seat: 'занять место в пассажирском вагоне',
  main: 'вернуться на главную'
}.freeze

NO_TRAINS_AVAILABLE_ERROR = 'Нет доступных поездов'
NO_ROUTES_AVAILABLE_ERROR = 'Нет доступных маршрутов'

# rubocop:disable Metrics/ModuleLength
module PageManage
  include Prompt
  include Highlight

  def manage_subpages
    %w[
      add_carriage
      remove_carriage
      add_intermidiate_station
      assign_route
      move_train
      occupy_volume
      occupy_seat
    ]
  end

  def manage
    print_menu(MENU_MANAGE)

    input = gets.chomp
    @page = manage_subpages.include?(input) ? "manage_#{input}" : 'main'
  end

  def manage_add_carriage
    puts 'Прицепка вагона'

    if trains.empty?
      puts NO_TRAINS_AVAILABLE_ERROR

      @page = 'manage'
      return
    end

    puts "Сейчас доступны следующие поезда: #{@trains.map(&:number).join(', ')}"

    puts 'Введите номер поезда для прицепки вагона:'

    train = prompt_for_train

    return unless train

    puts 'Введите номер вагона:'

    carriage_number = gets.chomp

    seats = prompt_for_seats if train.is_a?(PassengerTrain)
    volume = prompt_for_volume if train.is_a?(CargoTrain)

    carriage = if train.is_a?(PassengerTrain)
                 PassengerCarriage.new(carriage_number, seats)
               else
                 CargoCarriage.new(carriage_number, volume)
               end

    carriage.manufacturer = prompt_for_manufacturer

    train.add_carriage(carriage)

    puts "\nВагон #{carriage.number} прицеплен к поезду #{train.number}\n\n"

    @page = 'manage'
  end

  def manage_remove_carriage
    puts 'Отцепка вагона'

    if trains.empty?
      puts NO_TRAINS_AVAILABLE_ERROR

      @page = 'manage'
      return
    end

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

    if trains.empty?
      puts NO_ROUTES_AVAILABLE_ERROR

      @page = 'manage'
      return
    end

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

    if fitting_trains.empty?
      puts NO_TRAINS_AVAILABLE_ERROR

      @page = 'manage'
      return
    end

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

    if trains.empty?
      puts NO_TRAINS_AVAILABLE_ERROR

      @page = 'manage'
      return
    end

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

  def manage_occupy_volume
    puts 'Изменение объема грузового вагона'

    if trains.empty?
      puts NO_TRAINS_AVAILABLE_ERROR

      @page = 'manage'
      return
    end

    fitting_trains = @trains.select { |train| train.is_a?(CargoTrain) }.map(&:number)

    puts "Сейчас доступны следующие поезда: #{fitting_trains.join(', ')}"

    puts 'Введите номер поезда для изменения объема грузового вагона:'

    train = prompt_for_train

    return unless train

    puts "У этого поезда есть следующие вагоны: #{train.carriages.map(&:number).join(', ')}"

    carriage = prompt_for_carriage(train.carriages)

    return unless carriage

    puts "Введите занимаемый объем для добавления груза (сейчас #{carriage.occupied_volume} / #{carriage.volume}):"

    volume = gets.chomp.to_i

    carriage.fill(volume)

    puts "Текущий объем: #{carriage.occupied_volume} / #{carriage.volume}"

    @page = 'manage'
  end

  def manage_occupy_seat
    puts 'Занятие места в пассажирском вагоне'

    if trains.empty?
      puts NO_TRAINS_AVAILABLE_ERROR

      @page = 'manage'
      return
    end

    fitting_trains = @trains.select { |train| train.is_a?(PassengerTrain) }.map(&:number)

    puts "Сейчас доступны следующие поезда: #{fitting_trains.join(', ')}"

    puts 'Введите номер поезда для занятия места в пассажирском вагоне:'

    train = prompt_for_train

    return unless train

    puts "У этого поезда есть следующие вагоны: #{train.carriages.map(&:number).join(', ')}"

    carriage = prompt_for_carriage(train.carriages)

    return unless carriage

    carriage.occupy_seat

    puts "Теперь в вагоне занято #{carriage.occupied_seats} из #{carriage.seats_number} мест"

    @page = 'manage'
  end
end
# rubocop:enable Metrics/ModuleLength
