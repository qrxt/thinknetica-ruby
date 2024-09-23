# frozen_string_literal: true

require_relative '../manufacturer'
require_relative '../utils/validation/validation'

class Carriage
  include Manufacturer
  include Validation

  attr_reader :number

  validate :number, :presence
  validate :number, :len_max, 2

  def initialize(number)
    @number = number
  end
end
