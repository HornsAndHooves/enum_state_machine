if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start { add_filter '/test/' }
end

#require 'test/unit'
require 'minitest'
require "minitest/autorun"
require 'enum_state_machine'

def reset_rails_logger
  Rails.logger = Logger.new(STDERR).tap do |logger|
    logger.formatter = proc { |*, msg| "#{msg}\n" }
  end
end

reset_rails_logger

def set_rails_logger(io)
  Rails.logger.instance_variable_get(:@logdev).tap do
    Rails.logger.instance_variable_set(:@logdev, Logger::LogDevice.new(io))
  end
end

def set_log_device(logdev, io)
  logdev.instance_variable_set(:@dev, io)
end

class Minitest::Test
  def assert_nothing_raised
    yield
  rescue => ex
    assert_nil ex
  end

  alias_method :assert_nothing_thrown, :assert_nothing_raised
end
