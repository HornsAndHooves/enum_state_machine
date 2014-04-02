module EnumStateMachine
  # Graphing extensions aren't required, so they're loaded when referenced
  autoload :Graph, 'enum_state_machine/graph'
end

# Load all of the core implementation required to use state_machine.  This
# includes:
# * EnumStateMachine::MacroMethods which adds the state_machine DSL to your class
# * A set of initializers for setting state_machine defaults based on the current
#   running environment (such as within Rails)
require 'enum_state_machine/macro_methods'
require 'enum_state_machine/initializers'
