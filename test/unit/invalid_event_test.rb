require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class InvalidEventTest < MiniTest::Test
  def setup
    @object = Object.new
    @invalid_event = EnumStateMachine::InvalidEvent.new(@object, :invalid)
  end
  
  def test_should_have_an_object
    assert_equal @object, @invalid_event.object
  end
  
  def test_should_have_an_event
    assert_equal :invalid, @invalid_event.event
  end
  
  def test_should_generate_a_message
    assert_equal ':invalid is an unknown state machine event', @invalid_event.message
  end
end
