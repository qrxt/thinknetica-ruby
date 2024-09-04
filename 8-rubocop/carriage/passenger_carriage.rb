# frozen_string_literal: true

require_relative 'carriage'

class PassengerCarriage < Carriage
  attr_reader :seats_number, :occupied_seats

  def initialize(number, seats_number)
    super(number)

    @seats_number = seats_number
    @occupied_seats = 0
  end

  def occupy_seat
    @occupied_seats += 1 if free_seats.positive?
  end

  def free_seats
    @seats_number - @occupied_seats
  end

  def type_label
    'пассажирский'
  end

  def info
    "Вагон №#{@number}, тип: #{type_label}, занято мест: #{@occupied_seats}, свободно мест: #{free_seats}"
  end
end