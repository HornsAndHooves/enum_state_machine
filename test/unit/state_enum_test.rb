require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class StateEnumTest < MiniTest::Test
  def setup
    @klass = Class.new do
      def self.has_enumerated enum_attr, enum_opts
        class_eval do
          define_method enum_attr do
            @enum_attr
          end

          define_method :"#{enum_attr}=" do |value|
            @enum_attr = value
          end
        end
      end
    end

    @klass.send :include, EnumStateMachine::StateEnum
  end

  def test_should_allow_state_enum_on_any_class
    assert @klass.respond_to?(:has_state_enum)
  end

  def test_should_allow_power_enum_in_any_class
    @klass.class_eval do
      has_state_enum :state, :vehicle_state

      state_machine :state, initial: :new do
        state :new
        state :used

        event :buy do
          transition new: :used
        end
      end
    end

    assert @klass.respond_to?(:has_enumerated)

    object = @klass.new
    object.state = :new

    assert_equal "new", object.state

    object.buy!
    assert_equal "used", object.state
  end
end
