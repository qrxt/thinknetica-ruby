# frozen_string_literal: true

class Station
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
end
