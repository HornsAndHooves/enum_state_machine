require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class MatcherHelpersAllTest < MiniTest::Test
  include EnumStateMachine::MatcherHelpers
  
  def setup
    @matcher = all
  end
  
  def test_should_build_an_all_matcher
    assert_equal EnumStateMachine::AllMatcher.instance, @matcher
  end
end

class MatcherHelpersAnyTest < MiniTest::Test
  include EnumStateMachine::MatcherHelpers
  
  def setup
    @matcher = any
  end
  
  def test_should_build_an_all_matcher
    assert_equal EnumStateMachine::AllMatcher.instance, @matcher
  end
end

class MatcherHelpersSameTest < MiniTest::Test
  include EnumStateMachine::MatcherHelpers
  
  def setup
    @matcher = same
  end
  
  def test_should_build_a_loopback_matcher
    assert_equal EnumStateMachine::LoopbackMatcher.instance, @matcher
  end
end
