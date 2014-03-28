if defined?(Rails)
  # Track all of the applicable locales to load
  locale_paths = []
  EnumStateMachine::Integrations.all.each do |integration|
    locale_paths << integration.locale_path if integration.available? && integration.locale_path
  end
  
  if defined?(Rails::Engine)
    # Rails 3.x
    class EnumStateMachine::RailsEngine < Rails::Engine
      rake_tasks do
        load 'tasks/state_machine.rb'
      end
    end
    
    if Rails::VERSION::MAJOR == 3 && Rails::VERSION::MINOR == 0
      EnumStateMachine::RailsEngine.paths.config.locales = locale_paths
    else
      EnumStateMachine::RailsEngine.paths['config/locales'] = locale_paths
    end
  end
end
