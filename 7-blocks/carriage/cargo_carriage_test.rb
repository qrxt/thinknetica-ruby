# frozen_string_literal: true

require 'test/unit'
require_relative './cargo_carriage'

class TestCargoCarriage < Test::Unit::TestCase
  def test_cargo_carriage_initial
    carriage = CargoCarriage.new('02', 10_000)

    assert_equal('02', carriage.number)
    assert_equal(10_000, carriage.volume)
    assert_equal(0, carriage.occupied_volume)
    assert_equal(10_000, carriage.available_volume)
  end

  def test_cargo_carriage_occupy_volume
    carriage = CargoCarriage.new('02', 10_000)

    carriage.fill(2_500)

    assert_equal(2_500, carriage.occupied_volume)
    assert_equal(7_500, carriage.available_volume)
  end

  def test_cargo_carriage_cant_occupy_volume
    carriage = CargoCarriage.new('02', 1_000)

    carriage.fill(2_000)

    assert_equal(0, carriage.occupied_volume)
    assert_equal(1_000, carriage.available_volume)
  end
end
