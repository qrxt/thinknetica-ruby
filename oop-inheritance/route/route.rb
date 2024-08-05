class Route
  attr_reader :name, :intermidiate_stations, :arrival_station, :departure_station

  def initialize(name, departure_station, arrival_station)
    @name = name
    @departure_station = departure_station
    @arrival_station = arrival_station

    @intermidiate_stations = []
  end

  def add_intermidiate_station(station)
    @intermidiate_stations << station
  end

  def remove_intermidiate_station(station_name)
    @intermidiate_stations = @intermidiate_stations.reject { |station| station.name == station_name }
  end

  def stations()
    [@departure_station, @intermidiate_stations, @arrival_station].flatten
  end

  def has_station?(name)
    stations.map {|station| station.name }.include?(name)
  end

  def info()
    stations.map {|station| station.name }.join("-")
  end
end
