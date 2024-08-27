# frozen_string_literal: true

module Highlight
  def highlight(text)
    "\e[33m#{text}\e[0m"
  end
end
