require "test/unit"
require_relative 'day_index'

include DayIndex

class TestDayIndex < Test::Unit::TestCase
  def test_leap_year
    assert_equal(true, leap_year?(2000))
    assert_equal(true, leap_year?(2032))
    assert_equal(true, leap_year?(2028))
    assert_equal(true, leap_year?(2024))
    assert_equal(true, leap_year?(2020))
    assert_equal(true, leap_year?(1996))
    assert_equal(true, leap_year?(1992))
    assert_equal(true, leap_year?(1988))
    assert_equal(true, leap_year?(1952))

    assert_equal(false, leap_year?(1700))
    assert_equal(false, leap_year?(1800))
    assert_equal(false, leap_year?(1900))
    assert_equal(false, leap_year?(2100))
    assert_equal(false, leap_year?(2200))
    assert_equal(false, leap_year?(2300))
    assert_equal(false, leap_year?(2500))
    assert_equal(false, leap_year?(2600))
    assert_equal(false, leap_year?(1903))
    assert_equal(false, leap_year?(1927))
    assert_equal(false, leap_year?(1922))
  end

  def test_days_in_month
    assert_equal(31, days_in_month(:january))
    assert_equal(31, days_in_month(:january, 1900))

    assert_equal(28, days_in_month(:february))
    assert_equal(28, days_in_month(:february, 1700))

    assert_equal(29, days_in_month(:february, 2000))
  end

  def test_day_index
    # leap years
    assert_equal(178, day_index(26, 6, 2024))
    assert_equal(102, day_index(11, 4, 2000))

    # non-leap years
    assert_equal(177, day_index(26, 6, 2023))

    # start of year
    assert_equal(3, day_index(3, 1, 1999))
    assert_equal(34, day_index(3, 2, 1999))

    # end of year
    assert_equal(365, day_index(31, 12, 2023))

    # works like Date#yday
    assert_equal(Time.new(2024,6,26).yday, day_index(26, 6, 2024))
    assert_equal(Time.new(2023,12,24).yday, day_index(24, 12, 2023))
    assert_equal(Time.new(1900,2,3).yday, day_index(3, 2, 1900))
    assert_equal(Time.new(2000,4,11).yday, day_index(11, 4, 2000))
    assert_equal(Time.new(1999,1,3).yday, day_index(3, 1, 1999))
    assert_equal(Time.new(1999,2,3).yday, day_index(3, 2, 1999))
    assert_equal(Time.new(2023,12,31).yday, day_index(31, 12, 2023))
  end
end
