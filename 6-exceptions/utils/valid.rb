# frozen_string_literal: true

module Valid
  def valid?
    validate!
  rescue RuntimeError
    false
  end
end
