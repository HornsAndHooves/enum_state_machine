module EnumStateMachine
  module YARD
    # YARD custom handlers for integrating the state_machine DSL with the
    # YARD documentation system
    module Handlers
    end
  end
end

Dir["#{File.dirname(__FILE__)}/handlers/*.rb"].sort.each do |path|
  require "enum_state_machine/yard/handlers/#{File.basename(path)}"
end
