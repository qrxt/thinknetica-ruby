# frozen_string_literal: true

require_relative '../utils/instance_counter/instance_counter'
require_relative '../utils/validation/validation'

class Route
  include InstanceCounter
  include Validation

  attr_reader :name, :intermidiate_stations, :arrival_station, :departure_station

  validate :name, :presence
  validate :name, :len_min, 2

  validate :arrival_station, :presence
  validate :arrival_station, :type, Station
  validate :arrival_station, :inequality, [:departure_station]

  validate :departure_station, :presence
  validate :departure_station, :type, Station

  def initialize(name, departure_station, arrival_station)
    @name = name
    @departure_station = departure_station
    @arrival_station = arrival_station
    @intermidiate_stations = []

    validate!
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
