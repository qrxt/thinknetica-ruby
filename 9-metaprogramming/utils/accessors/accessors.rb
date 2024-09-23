# frozen_string_literal: true

module Accessors
  def attr_accessor_with_history(*names)
    names.each do |name|
      history = []
      var_name = "@#{name}".to_sym

      define_method(name) { instance_variable_get(var_name) }

      define_method("#{name}=".to_sym) do |value|
        instance_variable_set(var_name, value)
        history << value
      end

      define_method("#{name}_history".to_sym) { history }
    end
  end

  def strong_attr_accessor(name, attr_class)
    var_name = "@#{name}".to_sym

    define_method(name) { instance_variable_get(var_name) }

    define_method("#{name}=".to_sym) do |value|
      class_mismatch_error = "Ожидалось значение класса #{attr_class.name}, передано #{value.class.name}"

      raise class_mismatch_error unless value.is_a?(attr_class)

      instance_variable_set(var_name, value)
    end
  end
end
