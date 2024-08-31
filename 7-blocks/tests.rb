# frozen_string_literal: true

Dir["#{File.dirname(File.absolute_path(__FILE__))}/**/*_test.rb"]
  .sort { |a, b| a <=> b }
  .each { |file| require file }
