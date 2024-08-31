# frozen_string_literal: true

require_relative '../manufacturer'
require_relative '../utils/valid'

class Carriage
  include Manufacturer
  include Valid

  attr_reader :number

  def initialize(number)
    @number = number
    validate!
  end

  def validate!
    error_empty = 'Номера вагона обязателен'
    error_invalid_len = 'Длина номера должна быть меньше или равной двум'

    raise error_empty if number.nil?

    raise error_invalid_len if number.empty? || number.size > 2
  end
end
