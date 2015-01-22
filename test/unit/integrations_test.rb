require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class IntegrationMatcherTest < MiniTest::Test
  def setup
    superclass = Class.new
    self.class.const_set('Vehicle', superclass)
    
    @klass = Class.new(superclass)
  end
  
  def test_should_return_nil_if_no_match_found
    assert_nil EnumStateMachine::Integrations.match(@klass)
  end
  
  def test_should_return_integration_class_if_match_found
    integration = Module.new do
      include EnumStateMachine::Integrations::Base
      
      def self.matching_ancestors
        ['IntegrationMatcherTest::Vehicle']
      end
    end
    EnumStateMachine::Integrations.const_set('Custom', integration)
    
    assert_equal integration, EnumStateMachine::Integrations.match(@klass)
  ensure
    EnumStateMachine::Integrations.send(:remove_const, 'Custom')
  end
  
  def test_should_return_nil_if_no_match_found_with_ancestors
    assert_nil EnumStateMachine::Integrations.match_ancestors(['IntegrationMatcherTest::Fake'])
  end
  
  def test_should_return_integration_class_if_match_found_with_ancestors
    integration = Module.new do
      include EnumStateMachine::Integrations::Base
      
      def self.matching_ancestors
        ['IntegrationMatcherTest::Vehicle']
      end
    end
    EnumStateMachine::Integrations.const_set('Custom', integration)
    
    assert_equal integration, EnumStateMachine::Integrations.match_ancestors(['IntegrationMatcherTest::Fake', 'IntegrationMatcherTest::Vehicle'])
  ensure
    EnumStateMachine::Integrations.send(:remove_const, 'Custom')
  end
  
  def teardown
    self.class.send(:remove_const, 'Vehicle')
  end
end

class IntegrationFinderTest < MiniTest::Test
  def test_should_find_base
    assert_equal EnumStateMachine::Integrations::Base, EnumStateMachine::Integrations.find_by_name(:base)
  end
  
  def test_should_find_active_model
    assert_equal EnumStateMachine::Integrations::ActiveModel, EnumStateMachine::Integrations.find_by_name(:active_model)
  end
  
  def test_should_find_active_record
    assert_equal EnumStateMachine::Integrations::ActiveRecord, EnumStateMachine::Integrations.find_by_name(:active_record)
  end

  def test_should_raise_an_exception_if_invalid
    exception = assert_raises(EnumStateMachine::IntegrationNotFound) { EnumStateMachine::Integrations.find_by_name(:invalid) }
    assert_equal ':invalid is an invalid integration', exception.message
  end
end
