# frozen_string_literal: true

require_relative '../utils/instance_counter/instance_counter'
require_relative '../utils/valid'

class Station
  include InstanceCounter
  include Valid

  # rubocop:disable Style/ClassVars
  @@stations = []
  # rubocop:enable Style/ClassVars

  class << self
    def all
      @@stations
    end
  end

  attr_reader :name, :trains

  def initialize(name)
    @name = name
    @trains = []
    @@stations << self

    validate!
    register_instance
  end

  def add_train(train)
    @trains << train
  end

  def remove_train(train_number)
    @trains = @trains.reject { |train| train_number == train.number }
  end

  def train_types
    @trains.group_by(&:class)
  end

  def send(train_number)
    current_train = @trains.find { |train| train.number == train_number }

    current_train.go_next_station
  end

  def validate!
    error_empty = 'Название станции обязательно'
    error_invalid_len = 'Длина названия должна быть более одного символа'

    raise error_empty if name.nil?

    raise error_invalid_len if name.empty?
  end
end
