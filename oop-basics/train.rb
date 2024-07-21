class Train
  attr_accessor :speed
  attr_reader :number, :type, :number_of_carriages, :current_station, :current_route

  def initialize(number, type, number_of_carriages = 1)
    @number = number
    @type = type
    @number_of_carriages = number_of_carriages

    @speed = 0
  end

  def stop
    self.speed = 0
  end

  def manage_carriages(type = :coupling)
    return nil if !@speed.zero?

    case type
    when :coupling then @number_of_carriages += 1
    when :decoupling then @number_of_carriages -= 1
    end
  end

  def add_carriage()
    self.manage_carriages(:coupling)
  end

  def remove_carriage()
    self.manage_carriages(:decoupling)
  end

  def assign_route(route)
    @current_route = route
    @current_station = @current_route.departure_station

    @current_station.add_train(self)
  end

  def next_station(direction = :forward)
    return nil if !@current_route

    current_station_index = @current_route.get_stations.index { |station| station.name == @current_station.name }
    current_station = @current_route.get_stations()[current_station_index]

    next_station_index = direction == :backward ? current_station_index - 1 : current_station_index + 1
    next_station = @current_route.get_stations()[next_station_index]

    return current_station if !next_station
    return next_station unless next_station_index < 0
    @current_station
  end

  def move(direction)
    next_station = direction == :backward ? next_station(:backward) : next_station(:forward)

    @current_station.trains = @current_station.trains.reject { |train| train.number == self.number }

    @current_station = next_station

    @current_station.trains << self
  end

  def move_forward()
    move(:forward)
  end

  def move_backward()
    move(:backward)
  end

  def previous_station()
    next_station(:backward)
  end
end
