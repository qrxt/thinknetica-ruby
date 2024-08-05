class Train
  attr_reader :number, :carriages, :current_route, :speed

  def initialize(number)
    raise "Train не может быть инициализирован напрямую" if self.class == Train

    @number = number
    @carriages = []

    @speed = 0
  end

  def start
    start! if stopped?
  end

  def stopped?
    @speed.zero?
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

  def remove_carriage(number)
    @carriages = @carriages.reject { |carriage| carriage.number == number }
  end

  def info()
    return "#{self.class} #{@number}"
  end

  def add_carriage(carriage)
    @carriages << carriage if speed.zero?
  end

  protected

  def initial_speed() # метод для внутреннего использования, снаружи не используется
    60
  end

  def start!() # метод для внутреннего использования, для внешнего - start
    self.speed = initial_speed
  end

  private

  attr_writer :speed # Мы не должны иметь доступ к изменению скорости напрямую
end
