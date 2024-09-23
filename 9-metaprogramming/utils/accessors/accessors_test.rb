# frozen_string_literal: true

require_relative './accessors'

class X
  extend Accessors

  attr_accessor_with_history :test_attr_initial, :test_attr1, :test_attr2
end

class Y
  extend Accessors

  strong_attr_accessor :test_attr_typed, Numeric
end

class TestAccessors < Test::Unit::TestCase
  # attr_accessor_with_history
  def test_attr_accessor_initial
    x = X.new

    assert_equal(nil, x.test_attr_initial)
    assert_equal([], x.test_attr_initial_history)
  end

  def test_attr_accessor_setter
    x = X.new

    x.test_attr1 = 1

    assert_equal(1, x.test_attr1)
  end

  def test_attr_accessor_history
    x = X.new

    x.test_attr1 = 1
    x.test_attr1 = 2
    x.test_attr2 = 3
    x.test_attr2 = 4

    assert_equal([1, 2], x.test_attr1_history)
    assert_equal([3, 4], x.test_attr2_history)
  end

  # strong_attr_accessor
  def test_strong_attr_accessor
    y = Y.new

    y.test_attr_typed = 10

    assert_equal(10, y.test_attr_typed)

    assert_raise RuntimeError do
      y.test_attr_typed = 'hello'
    end
  end
end
