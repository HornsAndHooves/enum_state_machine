require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class ErrorByDefaultTest < MiniTest::Test
  def setup
    @machine = EnumStateMachine::Machine.new(Class.new)
    @collection = EnumStateMachine::NodeCollection.new(@machine)
  end
  
  def test_should_not_have_any_nodes
    assert_equal 0, @collection.length
  end
  
  def test_should_have_a_machine
    assert_equal @machine, @collection.machine
  end
  
  def test_should_index_by_name
    @collection << object = Struct.new(:name).new(:parked)
    assert_equal object, @collection[:parked]
  end
end

class ErrorWithMessageTest < MiniTest::Test
  def setup
    @machine = EnumStateMachine::Machine.new(Class.new)
    @collection = EnumStateMachine::NodeCollection.new(@machine)
  end
  
  def test_should_raise_exception_if_invalid_option_specified
    exception = assert_raises(ArgumentError) { EnumStateMachine::NodeCollection.new(@machine, :invalid => true) }
    assert_equal 'Invalid key(s): invalid', exception.message
  end
  
  def test_should_raise_exception_on_lookup_if_invalid_index_specified
    exception = assert_raises(ArgumentError) { @collection[:something, :invalid] }
    assert_equal 'Invalid index: :invalid', exception.message
  end
  
  def test_should_raise_exception_on_fetch_if_invalid_index_specified
    exception = assert_raises(ArgumentError) { @collection.fetch(:something, :invalid) }
    assert_equal 'Invalid index: :invalid', exception.message
  end
end
