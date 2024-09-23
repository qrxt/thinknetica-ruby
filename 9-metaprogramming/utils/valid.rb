# frozen_string_literal: true

module Valid
  def valid?
    validate!
    true
  rescue ArgumentError
    false
  end
end
