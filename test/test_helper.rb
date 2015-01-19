if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start { add_filter '/test/' }
end

#require 'test/unit'
require 'minitest'
require "minitest/autorun"
require 'enum_state_machine'

class MiniTest::Test
  def assert_nothing_raised
    yield
  rescue => ex
    assert_nil ex
  end

  alias_method :assert_nothing_thrown, :assert_nothing_raised
end
