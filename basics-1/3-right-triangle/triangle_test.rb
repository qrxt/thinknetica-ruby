require "test/unit"
require_relative 'triangle_kind'

include TriangleKind

class TestTriangleKind < Test::Unit::TestCase
  def test_right_triangle?
    assert_equal(true, right_triangle?([3,4,5]))
    assert_equal(true, right_triangle?([8,6,10]))

    assert_equal(false, right_triangle?([1,2,3]))
    assert_equal(false, right_triangle?([2,3,5]))
  end

  def test_equilateral_triangle?
    assert_equal(true, equilateral_triangle?([3,3,3]))
    assert_equal(true, equilateral_triangle?([12,12,12]))

    assert_equal(false, equilateral_triangle?([4,1,4]))
    assert_equal(false, equilateral_triangle?([7,8,12]))
  end

  def test_isosceles_triangle?
    assert_equal(true, isosceles_triangle?([3,2,3]))
    assert_equal(true, isosceles_triangle?([12,8,12]))

    assert_equal(false, isosceles_triangle?([4,4,4]))
    assert_equal(false, isosceles_triangle?([1,2,3]))
  end

  def test_triangle?
    assert_equal(true, triangle?([3,2,3]))

    assert_equal(false, triangle?([1,2,3]))
    assert_equal(false, triangle?([40,50,100]))
    assert_equal(false, triangle?([-1,2,1]))
  end

  def test_determine_triangle_kind
    assert_equal(:right, determine_triangle_kind([8,15,17]))
    assert_equal(:right, determine_triangle_kind([3,4,5]))
    assert_equal(:right, determine_triangle_kind([8,6,10]))

    assert_equal(:equilateral, determine_triangle_kind([3,3,3]))
    assert_equal(:equilateral, determine_triangle_kind([9,9,9]))

    assert_equal(:isosceles, determine_triangle_kind([3,4,3]))
    assert_equal(:isosceles, determine_triangle_kind([2,1,2]))

    assert_equal(:scalene, determine_triangle_kind([1,2,3]))
    assert_equal(:scalene, determine_triangle_kind([4,5,6]))
  end
end
