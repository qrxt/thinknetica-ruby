require "test/unit"
require_relative 'fib'

include Fib

class TestFib < Test::Unit::TestCase
  def test_fill_array
    assert_equal([0, 1, 1, 2, 3, 5, 8], fib(10))
  end
end
