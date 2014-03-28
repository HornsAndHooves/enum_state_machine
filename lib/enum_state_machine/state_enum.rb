require 'power_enum'

module EnumStateMachine
  module StateEnum
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def has_state_enum(enum_name, method_name)
        has_enumerated enum_name

        define_method "#{method_name}" do
          public_send("#{enum_name}").to_s
        end

        define_method "#{method_name}=" do |value|
          public_send("#{enum_name}=", value)
        end
      end
    end
  end
end
