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

PAGE = {
  'main' => :main,
  'stop' => :stop,
  'seed' => :seed,
  'display' => :display,
  'display_trains' => :display_trains,
  'display_stations' => :display_stations,
  'display_routes' => :display_routes,
  'display_report' => :display_report,
  'create' => :create,
  'create_train' => :create_train,
  'create_station' => :create_station,
  'create_route' => :create_route,
  'manage' => :manage,
  'manage_add_carriage' => :manage_add_carriage,
  'manage_remove_carriage' => :manage_remove_carriage,
  'manage_add_intermidiate_station' => :manage_add_intermidiate_station,
  'manage_assign_route' => :manage_assign_route,
  'manage_move_train' => :manage_move_train,
  'manage_occupy_volume' => :manage_occupy_volume,
  'manage_occupy_seat' => :manage_occupy_seat
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

  def open_page
    page = PAGE[@page]

    page ? send(page) : not_found
  end

  def menu
    while @is_running
      break if @page == 'stop'

      open_page
    end
  end

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
