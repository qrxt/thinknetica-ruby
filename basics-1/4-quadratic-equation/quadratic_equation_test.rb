require "test/unit"
require_relative 'quadratic_equation'

include QuadraticEquation

class TestQuadraticEquation < Test::Unit::TestCase
  def test_get_square_roots
    # two roots
    assert_equal({ "discriminant" => 16, "roots" => [6, 2] }, get_square_roots(1, -8, 12))

    # one root
    assert_equal({ "discriminant" => 0, "roots" => [3] }, get_square_roots(1, -6, 9))

    # no roots
    assert_equal({ "discriminant" => -131, "roots" => [] }, get_square_roots(5, 3, 7))
  end
end
