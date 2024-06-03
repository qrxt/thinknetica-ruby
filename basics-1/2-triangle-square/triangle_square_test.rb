require "test/unit"
require_relative 'triangle_square'

include TriangleSquare

class TestSimpleNumber < Test::Unit::TestCase
  def test_int
    assert_equal(3, calc_triangle_square(3, 2))
    assert_equal(10, calc_triangle_square(5, 4))
  end

  def test_float
    assert_equal(6.88, calc_triangle_square(3.2, 4.3))
  end
end
