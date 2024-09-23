# frozen_string_literal: true

VALIDATOR = {
  'presence' => :validate_presence,
  'format' => :validate_format,
  'len_min' => :validate_len_min,
  'len_max' => :validate_len_max,
  'inequality' => :validate_inequality,
  'type' => :validate_type
}.freeze

module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_accessor :validators

    def validate(name, validation_type, *additional)
      @validators ||= []
      @validators << { name: name, validation_type: validation_type, additional: additional }
    end
  end

  module InstanceMethods
    def validate!
      results = execute_validators.compact

      raise ArgumentError, results.first if results.any?
    end

    def valid?
      execute_validators.empty?
    end

    private

    def execute_validators
      own_validators = self.class.validators || []
      parent_validators = self.class.superclass != Object ? self.class.superclass.validators : []
      combined_validators = own_validators.concat(parent_validators)

      combined_validators.flat_map(&method(:execute_validator))
    end

    def execute_validator(validator)
      name = validator[:name]
      value = instance_variable_get("@#{name}".to_sym)
      additional = validator[:additional]

      validator_key = validator[:validation_type].to_s
      fitting_validator = VALIDATOR[validator_key]

      raise "Валидатор #{validator_key} не найден" unless fitting_validator

      __send__(fitting_validator, name, value, *additional)
    end

    def validate_presence(name, value)
      error_empty = "Атрибут :#{name} класса #{self.class.name} не может быть пустым"

      error_empty if value.to_s.empty?
    end

    def validate_format(name, value, format)
      return nil unless format

      error_invalid_format = "Атрибут :#{name} класса #{self.class.name} имеет некорректный формат"

      error_invalid_format if value !~ format
    end

    def validate_len_min(name, value, min_len)
      return nil if !min_len || value.to_s.empty?

      error_invalid_len = "Атрибут :#{name} класса #{self.class.name} должен иметь длину не менее #{min_len}"

      error_invalid_len if value.size < min_len
    end

    def validate_len_max(name, value, max_len)
      return nil if !max_len || value.to_s.empty?

      error_invalid_len = "Атрибут :#{name} класса #{self.class.name} должен иметь длину не более #{max_len}"

      error_invalid_len if value.size > max_len
    end

    def validate_inequality(name, value, attrs)
      inequal_attrs = attrs.map { |attr| ":#{attr}" }.join(', ')
      error_inequal = "Атрибут :#{name} не должен быть равен атрибутам [#{inequal_attrs}]"

      attr_values = attrs.map do |attr|
        var_name = "@#{attr}".to_sym
        instance_variable_get(var_name)
      end

      error_inequal if attr_values.all?(value)
    end

    def validate_type(name, value, expected_class)
      return nil unless expected_class

      error_invalid_type = "Атрибут :#{name} должен быть инстансом класса #{expected_class}"

      error_invalid_type unless value.instance_of?(expected_class)
    end
  end
end
