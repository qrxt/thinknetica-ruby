# frozen_string_literal: true

require_relative './validation'

class ValidatedClassForTest
  include Validation

  attr_reader :number

  validate :number, :presence
  validate :number, :format, /^[a-zA-Z0-9]{3}-?[a-zA-Z0-9]{2}$/

  def initialize(number)
    @number = number

    validate!
  end
end

class ValidatedClassAttrsTypeForTest
  include Validation

  attr_reader :str

  validate :str, :type, String

  def initialize(str)
    @str = str

    validate!
  end
end

class ValidatedClassWithInequalAttrsForTest
  include Validation

  attr_reader :arrival_station, :departure_station

  validate :arrival_station, :inequality, [:departure_station]

  def initialize(arrival_station, departure_station)
    @arrival_station = arrival_station
    @departure_station = departure_station

    validate!
  end
end

class ValidatedClassAttrsLenForTest
  include Validation

  attr_reader :value

  validate :value, :len_min, 2
  validate :value, :len_max, 5

  def initialize(value)
    @value = value

    validate!
  end
end

class TestValidation < Test::Unit::TestCase
  def test_validation_valid
    valid = ValidatedClassForTest.new('123-01')

    assert_equal('123-01', valid.number)
  end

  def test_validation_type
    assert_raise ArgumentError do
      ValidatedClassAttrsTypeForTest.new(123_01)
    end
  end

  def test_validation_invalid_presence
    assert_raise ArgumentError do
      ValidatedClassForTest.new('')
    end
  end

  def test_validation_invalid_format
    assert_raise ArgumentError do
      ValidatedClassForTest.new('12')
    end
  end

  def test_validation_inequality
    assert_raise ArgumentError do
      ValidatedClassWithInequalAttrsForTest.new('A', 'A')
    end
  end

  def test_validation_min_len
    assert_raise ArgumentError do
      ValidatedClassAttrsLenForTest.new('1')
    end
  end

  def test_validation_max_len
    assert_raise ArgumentError do
      ValidatedClassAttrsLenForTest.new('1234567')
    end
  end
end
