# frozen_string_literal: true

require 'test/unit'
require_relative './passenger_carriage'

class TestPassengerCarriage < Test::Unit::TestCase
  def test_passenger_carriage_initial
    carriage = PassengerCarriage.new('01', 36)

    assert_equal('01', carriage.number)
    assert_equal(36, carriage.seats_number)
    assert_equal(36, carriage.free_seats)
    assert_equal(0, carriage.occupied_seats)
  end

  def test_passenger_carriage_occupy_seat
    carriage = PassengerCarriage.new('01', 36)

    carriage.occupy_seat

    assert_equal(35, carriage.free_seats)
    assert_equal(1, carriage.occupied_seats)
  end

  def test_passenger_carriage_cant_occupy_seat
    carriage = PassengerCarriage.new('01', 1)

    carriage.occupy_seat

    assert_equal(0, carriage.free_seats)

    carriage.occupy_seat

    assert_equal(0, carriage.free_seats)
  end

  def test_passenger_carriage_validate_number
    assert_raise ArgumentError do
      PassengerCarriage.new('022', 30)
    end
  end

  def test_passenger_carriage_validate_seats
    assert_raise ArgumentError do
      PassengerCarriage.new('02', nil)
    end
  end
end
