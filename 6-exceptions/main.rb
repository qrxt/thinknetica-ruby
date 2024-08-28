# frozen_string_literal: true

require_relative 'railroad/railroad'
require_relative 'carriage/carriage'
require_relative 'train/passenger_train'
require_relative 'train/cargo_train'
require_relative 'station/station'
require_relative 'route/route'

rr = Railroad.new

rr.menu
