# frozen_string_literal: true

require_relative 'carriage'

class CargoCarriage < Carriage
  attr_reader :volume, :occupied_volume

  def initialize(number, volume)
    super(number)

    @volume = volume
    @occupied_volume = 0
  end

  def fill(volume)
    new_occupied_volume = @occupied_volume + volume
    @occupied_volume = new_occupied_volume if new_occupied_volume <= @volume
  end

  def available_volume
    @volume - @occupied_volume
  end

  def type_label
    'грузовой'
  end

  def info
    "Вагон №#{@number}, тип: #{type_label}, занятый объем: #{@occupied_volume}, доступный объем: #{available_volume}"
  end
end
