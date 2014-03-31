require 'power_enum'

module EnumStateMachine
  module StateEnum
    def self.included(base)
      base.extend ClassMethods if defined?(PowerEnum)
    end

    module ClassMethods
      def has_state_enum(state_attr, enum_attr, enum_opts = {})
        has_enumerated enum_attr, enum_opts

        define_method "#{state_attr}" do
          public_send("#{enum_attr}").to_s
        end

        define_method "#{state_attr}=" do |value|
          public_send("#{enum_attr}=", value)
        end
      end
    end
  end
end
