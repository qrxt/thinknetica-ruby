# frozen_string_literal: true

require_relative '../manufacturer'

class Carriage
  include Manufacturer
  attr_reader :number

  def initialize(number)
    @number = number
  end
end
