class Train
  attr_accessor :speed
  attr_reader :number, :type, :carriages, :current_route

  def initialize(number)
    raise "Train не может быть инициализирован напрямую" if self.class == Train

    @number = number
    @carriages = []

    @speed = 0
  end

  def stop
    self.speed = 0
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

  def add_carriage(carriage)
    @carriages << carriage if speed.zero?
  end

  def remove_carriage(number)
    @carriages = @carriages.reject { |carriage| carriage.number == number }
  end

  def info()
    return "#{self.class} #{@number}"
  end
end
