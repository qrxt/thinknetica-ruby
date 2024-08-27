# frozen_string_literal: true

module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    # rubocop:disable Style/ClassVars
    @@instances = {}
    # rubocop:enable Style/ClassVars

    def instances
      @@instances[self] ? @@instances[self].size : 0
    end

    def register_instance(instance)
      @@instances[self] ||= []
      @@instances[self] << instance
    end
  end

  module InstanceMethods
    def register_instance
      self.class.register_instance(self)
    end
  end
end
