# frozen_string_literal: true

require_relative '../utils/prompt'
require_relative '../utils/manage'
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

module PageManage
  include Prompt
  include Highlight
  include ManageUtils

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

    return if check_no_trains

    puts 'Введите номер поезда для прицепки вагона:'

    train = prompt_for_train

    return unless train

    carriage = create_carriage(train)

    train.add_carriage(carriage)

    puts "\nВагон #{carriage.number} прицеплен к поезду #{train.number}\n\n"

    @page = 'manage'
  end

  def manage_remove_carriage
    puts 'Отцепка вагона'

    return if check_no_trains

    puts 'Введите номер поезда для отцепки вагона:'

    train = prompt_for_train

    return unless train

    carriage_number = prompt_for_carriage_number(train.carriages)

    remove_carriage(train, carriage_number)

    @page = 'manage'
  end

  def manage_add_intermidiate_station
    puts 'Добавление промежуточной станции'

    return if check_no_trains

    puts 'Введите название маршрута для добавление промежуточной станции:'

    route = prompt_for_route

    return unless route

    fitting_stations = @stations.reject { |station| route.station?(station.name) }

    station = prompt_for_station(fitting_stations)

    return unless station

    route.add_intermidiate_station(station)

    @page = 'manage'
  end

  def manage_assign_route
    puts 'Назначение маршрута'

    fitting_trains = @trains.reject(&:current_route)

    return if check_no_trains(fitting_trains)

    train = prompt_for_train(fitting_trains)

    return unless train

    puts 'Введите название маршрута:'

    route = prompt_for_route

    return unless route

    assign_route(train, route)

    @page = 'manage'
  end

  def manage_move_train
    puts 'Передвижение поезда'

    return if check_no_trains

    puts 'Введите номер поезда для прицепки вагона:'

    train = prompt_for_train

    return unless train

    direction = prompt_for_direction

    previous_station = train.previous_station

    direction == 'backward' ? train.go_previous_station : train.go_next_station

    puts "Поезд передвинулся со станции #{previous_station.name} на станцию #{train.current_station.name}"

    @page = 'manage'
  end

  def manage_occupy_volume
    puts 'Изменение объема грузового вагона'

    return if check_no_trains

    fitting_trains = @trains.select { |train| train.is_a?(CargoTrain) }

    puts 'Введите номер поезда для изменения объема грузового вагона:'

    train = prompt_for_train(fitting_trains)

    return unless train

    carriage = prompt_for_carriage(train.carriages)

    return unless carriage

    occupy_carriage_volume(carriage, prompt_for_volume_fill(carriage))

    @page = 'manage'
  end

  def manage_occupy_seat
    puts 'Занятие места в пассажирском вагоне'

    return if check_no_trains

    fitting_trains = @trains.select { |train| train.is_a?(PassengerTrain) }

    puts 'Введите номер поезда для занятия места в пассажирском вагоне:'

    train = prompt_for_train(fitting_trains)

    return unless train

    carriage = prompt_for_carriage(train.carriages)

    return unless carriage

    occupy_carriage_seat(carriage)

    @page = 'manage'
  end
end
