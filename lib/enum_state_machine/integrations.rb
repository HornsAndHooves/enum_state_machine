# Load each available integration
require 'enum_state_machine/integrations/base'
Dir["#{File.dirname(__FILE__)}/integrations/*.rb"].sort.each do |path|
  require "enum_state_machine/integrations/#{File.basename(path)}"
end

require 'enum_state_machine/error'

module EnumStateMachine
  # An invalid integration was specified
  class IntegrationNotFound < Error
    def initialize(name)
      super(nil, "#{name.inspect} is an invalid integration")
    end
  end
  
  # Integrations allow state machines to take advantage of features within the
  # context of a particular library.  This is currently most useful with
  # database libraries.  For example, the various database integrations allow
  # state machines to hook into features like:
  # * Saving
  # * Transactions
  # * Observers
  # * Scopes
  # * Callbacks
  # * Validation errors
  # 
  # This type of integration allows the user to work with state machines in a
  # fashion similar to other object models in their application.
  # 
  # The integration interface is loosely defined by various unimplemented
  # methods in the EnumStateMachine::Machine class.  See that class or the various
  # built-in integrations for more information about how to define additional
  # integrations.
  module Integrations
    # Attempts to find an integration that matches the given class.  This will
    # look through all of the built-in integrations under the EnumStateMachine::Integrations
    # namespace and find one that successfully matches the class.
    # 
    # == Examples
    # 
    #   class Vehicle
    #   end
    #   
    #   class ActiveModelVehicle
    #     include ActiveModel::Observing
    #     include ActiveModel::Validations
    #   end
    #   
    #   class ActiveRecordVehicle < ActiveRecord::Base
    #   end
    #
    #
    #   EnumStateMachine::Integrations.match(Vehicle)             # => nil
    #   EnumStateMachine::Integrations.match(ActiveModelVehicle)  # => EnumStateMachine::Integrations::ActiveModel
    #   EnumStateMachine::Integrations.match(ActiveRecordVehicle) # => EnumStateMachine::Integrations::ActiveRecord
    def self.match(klass)
      all.detect {|integration| integration.matches?(klass)}
    end
    
    # Attempts to find an integration that matches the given list of ancestors.
    # This will look through all of the built-in integrations under the EnumStateMachine::Integrations
    # namespace and find one that successfully matches one of the ancestors.
    # 
    # == Examples
    # 
    #   EnumStateMachine::Integrations.match([])                    # => nil
    #   EnumStateMachine::Integrations.match(['ActiveRecord::Base') # => EnumStateMachine::Integrations::ActiveModel
    def self.match_ancestors(ancestors)
      all.detect {|integration| integration.matches_ancestors?(ancestors)}
    end
    
    # Finds an integration with the given name.  If the integration cannot be
    # found, then a NameError exception will be raised.
    # 
    # == Examples
    # 
    #   EnumStateMachine::Integrations.find_by_name(:active_record) # => EnumStateMachine::Integrations::ActiveRecord
    #   EnumStateMachine::Integrations.find_by_name(:active_model)  # => EnumStateMachine::Integrations::ActiveModel
    #   EnumStateMachine::Integrations.find_by_name(:invalid)       # => EnumStateMachine::IntegrationNotFound: :invalid is an invalid integration
    def self.find_by_name(name)
      all.detect {|integration| integration.integration_name == name} || raise(IntegrationNotFound.new(name))
    end
    
    # Gets a list of all of the available integrations for use.  This will
    # always list the ActiveModel integration last.
    # 
    # == Example
    # 
    #   EnumStateMachine::Integrations.all
    #   # => [EnumStateMachine::Integrations::ActiveRecord, EnumStateMachine::Integrations::ActiveModel]
    def self.all
      constants = self.constants.map {|c| c.to_s}.select {|c| c != 'ActiveModel'}.sort << 'ActiveModel'
      constants.map {|c| const_get(c)}
    end
  end
end
