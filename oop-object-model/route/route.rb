# frozen_string_literal: true

require_relative '../utils/instance_counter/instance_counter'

class Route
  include InstanceCounter

  attr_reader :name, :intermidiate_stations, :arrival_station, :departure_station

  def initialize(name, departure_station, arrival_station)
    @name = name
    @departure_station = departure_station
    @arrival_station = arrival_station
    @intermidiate_stations = []

    register_instance
  end

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
