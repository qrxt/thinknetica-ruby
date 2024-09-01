# frozen_string_literal: true

require_relative '../utils/prompt'
require_relative '../../utils/highlight'

MENU_DISPLAY = {
  trains: 'вывести список поездов',
  stations: 'вывести список станция',
  routes: 'вывести список маршрутов',
  report: 'вывести отчет',
  main: 'вернуться на главную'
}.freeze

module PageDisplay
  include Prompt
  include Highlight

  def display_subpages
    %w[trains stations routes report]
  end

  def display
    print_menu(MENU_DISPLAY)

    input = gets.chomp
    @page = display_subpages.include?(input) ? "display_#{input}" : 'main'
  end

  def display_trains
    puts "Список поездов:\n"

    @trains.each do |train|
      train_route_string = if train.current_route
                             "(Маршрут: #{train.current_route.info}, текущая станция: #{train.current_station.name})"
                           else
                             ''
                           end

      puts "\n#{train.info} #{train_route_string}"

      train.each_carriage { |carriage| puts "\t#{carriage.info}" }
    end

    @page = 'display'
  end

  def display_stations
    puts "Список станций:\n"

    @stations.each do |station|
      puts "\nСтанция #{station.name}\n"

      station.each_train { |train| puts "\t#{train.info}" }
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

  def display_report
    no_data_notice = "Нет данных для вывода. Можно создать сущности вручную или вызвать команду #{highlight('seed')}"

    puts "Отчет:\n\n"

    puts no_data_notice if @stations.empty?

    @stations.each do |station|
      puts "Станция #{station.name}"

      station.each_train do |train|
        puts "\t#{train.info}"

        train.each_carriage { |carriage| puts "\t\t#{carriage.info}" }
      end
    end

    puts "\n"

    @page = 'display'
  end
end
