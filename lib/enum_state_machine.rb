# By default, requiring "enum_state_machine" means that both the core implementation
# *and* extensions to the Ruby core (Class in particular) will be pulled in.
# 
# If you want to skip the Ruby core extensions, simply require "enum_state_machine/core"
# and extend EnumStateMachine::MacroMethods in your class.  See the README for more
# information.
require 'enum_state_machine/core'
require 'enum_state_machine/core_ext'
require 'enum_state_machine/state_enum'
