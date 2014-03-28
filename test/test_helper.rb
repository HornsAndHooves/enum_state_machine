if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start { add_filter '/test/' }
end

require 'test/unit'
require 'enum_state_machine'
