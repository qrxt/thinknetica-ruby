# frozen_string_literal: true

require_relative '../utils/instance_counter/instance_counter'
require_relative '../utils/valid'

class Route
  include InstanceCounter
  include Valid

  attr_reader :name, :intermidiate_stations, :arrival_station, :departure_station

  def initialize(name, departure_station, arrival_station)
    @name = name
    @departure_station = departure_station
    @arrival_station = arrival_station
    @intermidiate_stations = []

    validate!
    register_instance
  end

  # rubocop:disable Metrics/PerceivedComplexity
  def validate!
    error_empty = 'Название маршрута обязательно'
    error_invalid_len = 'Длина названия должна быть более двух символов'
    error_no_departure_station = 'Станция отправления обязательна'
    error_no_arrival_station = 'Станция прибытия обязательна'
    error_station_wrong_type = 'В качестве аргументов должны быть переданы объекты типа Station'
    error_same_stations = 'Станции отправления и прибытия должны быть разными'

    is_correct_typed = departure_station.instance_of?(Station) && arrival_station.instance_of?(Station)

    raise error_empty if name.nil?

    raise error_invalid_len if name.empty? || name.size < 2

    raise error_no_departure_station if departure_station.nil?

    raise error_no_arrival_station if arrival_station.nil?

    raise error_station_wrong_type unless is_correct_typed

    raise error_same_stations if departure_station == arrival_station
  end
  # rubocop:enable Metrics/PerceivedComplexity

  def add_intermidiate_station(station)
    @intermidiate_stations << station
  end

  def remove_intermidiate_station(station_name)
    @intermidiate_stations = @intermidiate_stations.reject { |station| station.name == station_name }
  end

  def stations
    [@departure_station, @intermidiate_stations, @arrival_station].flatten
  end

  def station?(name)
    stations.map(&:name).include?(name)
  end

  def info
    stations.map(&:name).join('-')
  end
end
