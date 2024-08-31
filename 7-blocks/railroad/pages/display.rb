# frozen_string_literal: true

require_relative '../utils/prompt'
require_relative '../../utils/highlight'

MENU_DISPLAY = {
  trains: 'вывести список поездов',
  stations: 'вывести список станция',
  routes: 'вывести список маршрутов',
  main: 'вернуться на главную'
}.freeze

module PageDisplay
  include Prompt
  include Highlight

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
end
