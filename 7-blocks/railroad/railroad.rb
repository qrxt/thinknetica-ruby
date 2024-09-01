# frozen_string_literal: true

require_relative '../utils/highlight'
require_relative '../carriage/carriage'
require_relative '../train/passenger_train'
require_relative '../train/cargo_train'
require_relative '../station/station'
require_relative '../route/route'
require_relative 'pages/create'
require_relative 'pages/display'
require_relative 'pages/manage'
require_relative 'utils/seed'

MENU_MAIN = {
  create: 'создать объект',
  manage: 'произвести операции над объектами',
  display: 'вывести данные об объектах',
  seed: 'сгенерировать начальный набор объектов',
  stop: 'завершить выполнение программы'
}.freeze

class Railroad
  include Highlight
  include PageCreate
  include PageDisplay
  include PageManage
  include Seed

  attr_reader :trains, :stations, :routes

  def initialize
    @is_running = true
    @page = 'main'

    @trains = []
    @stations = []
    @routes = []
  end

  # rubocop:disable Metrics/CyclomaticComplexity
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
      when 'display_report' then display_report

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
  # rubocop:enable Metrics/CyclomaticComplexity

  private

  # методы ниже не предназначены для вызова снаружи, подразумевается,
  # что все нужные действия можно выполнить через rr.menu

  attr_writer :trains, :stations, :routes

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

  attr_accessor :page, :is_running
end
