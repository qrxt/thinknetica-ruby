# frozen_string_literal: true

module Manufacturer
  def assign_manufacturer(name)
    self.manufacturer = name
  end

  def manufacturer
    @manufacturer
  end

  protected

  attr_writer :manufacturer
end
