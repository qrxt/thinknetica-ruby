require "test/unit"
require_relative 'fill_array'

include FillArray

class TestFillArray < Test::Unit::TestCase
  def test_fill_array
    assert_equal([10, 15, 20], fill_array(10, 20, 5))
    assert_equal([-1, 0, 1], fill_array(-1, 1, 1))

    assert_equal([1], fill_array(1, 1, 1))
    assert_equal([], fill_array(0, 0, 0))
  end
end
