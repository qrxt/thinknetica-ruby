# frozen_string_literal: true

require 'test/unit'
require_relative 'instance_counter'
require_relative '../../train/train'
require_relative '../../train/cargo_train'
require_relative '../../train/passenger_train'
require_relative '../../station/station'
require_relative '../../route/route'

class TestInstanceCounter < Test::Unit::TestCase
  def test_instances
    PassengerTrain.new('123-01')
    CargoTrain.new('123-02')
    station_a = Station.new('A')
    station_b = Station.new('B')
    Route.new('A-B', station_a, station_b)

    assert_equal(1, PassengerTrain.instances)
    assert_equal(1, CargoTrain.instances)
    assert_equal(0, Train.instances)
    assert_equal(2, Station.instances)
    assert_equal(1, Route.instances)
  end
end
