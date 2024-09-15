# frozen_string_literal: true

require_relative '../manufacturer'
require_relative '../utils/instance_counter/instance_counter'
require_relative '../utils/valid'

class Train
  include Manufacturer
  include InstanceCounter
  include Valid

  attr_reader :number, :carriages, :current_route, :speed

  # rubocop:disable Style/ClassVars
  @@trains = []
  # rubocop:enable Style/ClassVars

  class << self
    def find(number)
      @@trains.find { |train| train.number == number }
    end
  end

  def initialize(number)
    raise 'Train не может быть инициализирован напрямую' if instance_of?(Train)

    @number = number
    validate!

    @carriages = []
    @speed = 0

    @@trains << self
    register_instance
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

  def current_station
    @current_route.stations[@current_station_index] if @current_route
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

    current_station.remove_train(number)
    @current_station_index += 1
    current_station.add_train(self)

    current_station
  end

  def go_previous_station
    return if previous_station == current_station

    current_station.remove_train(number)
    @current_station_index -= 1
    current_station.add_train(self)

    current_station
  end

  def remove_carriage(number)
    @carriages = @carriages.reject { |carriage| carriage.number == number }
  end

  def info
    manufacturer_string = manufacturer.empty? ? '' : "производитель: #{manufacturer}"

    "Поезд №#{@number}: тип: #{type_label}, кол-во вагонов: #{@carriages.size}, #{manufacturer_string}"
  end

  def add_carriage(carriage)
    @carriages << carriage if speed.zero?
  end

  def each_carriage(&block)
    @carriages.each(&block)
  end

  def validate!
    error_empty = 'Номера поезда обязателен'
    error_incorrect_format = 'Номер поезда должен иметь формат: 3 цифры/буквы, необязательный дефис, 2 цифры/буквы'

    raise error_empty if number.nil?

    raise error_incorrect_format if number !~ /^[a-zA-Z0-9]{3}-?[a-zA-Z0-9]{2}$/
  end

  protected

  # метод для внутреннего использования, снаружи не используется
  def initial_speed
    60
  end

  # метод для внутреннего использования, для внешнего - start
  def start!
    self.speed = initial_speed
  end

  private

  attr_writer :speed # Мы не должны иметь доступ к изменению скорости напрямую
end
