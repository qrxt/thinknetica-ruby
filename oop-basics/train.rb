class Train
  attr_accessor :speed
  attr_reader :number, :type, :number_of_carriages, :current_route

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
    @current_station_index = 0

    current_station.add_train(self)
  end

  def current_station()
    return @current_route.stations()[@current_station_index] if @current_route
  end

  def next_station
    @current_route.stations[@current_station_index + 1] || current_station
  end

  def previous_station
    return current_station if @current_station_index < 1

    @current_route.stations[@current_station_index - 1]
  end

  def go_next_station
    return if current_station == next_station

    current_station.remove_train(self.number)
    @current_station_index += 1
    current_station.add_train(self)
  end

  def go_previous_station
    return if previous_station == current_station

    current_station.remove_train(self.number)
    @current_station_index -= 1
    current_station.add_train(self)
  end
end
