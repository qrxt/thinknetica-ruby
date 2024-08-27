require "test/unit"
require_relative 'ideal_weight'

include IdealWeight

class TestSimpleNumber < Test::Unit::TestCase
  def test_normal
    assert_equal(69, calc_ideal_weight(170))
    assert_equal(80.5, calc_ideal_weight(180))
    assert_equal(92, calc_ideal_weight(190))
  end

  def test_negative
    assert_equal(-11.5, calc_ideal_weight(100))
  end
end
