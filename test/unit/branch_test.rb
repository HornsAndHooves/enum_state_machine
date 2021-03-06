require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class BranchTest < MiniTest::Test
  def setup
    @branch = EnumStateMachine::Branch.new(:from => :parked, :to => :idling)
  end
  
  def test_should_not_raise_exception_if_implicit_option_specified
    assert_nothing_raised { EnumStateMachine::Branch.new(:invalid => :valid) }
  end
  
  def test_should_not_have_an_if_condition
    assert_nil @branch.if_condition
  end
  
  def test_should_not_have_an_unless_condition
    assert_nil @branch.unless_condition
  end
  
  def test_should_have_a_state_requirement
    assert_equal 1, @branch.state_requirements.length
  end
  
  def test_should_raise_an_exception_if_invalid_match_option_specified
    exception = assert_raises(ArgumentError) { @branch.match(Object.new, :invalid => true) }
    assert_equal 'Invalid key(s): invalid', exception.message
  end
end

class BranchWithNoRequirementsTest < MiniTest::Test
  def setup
    @object = Object.new
    @branch = EnumStateMachine::Branch.new
  end
  
  def test_should_use_all_matcher_for_event_requirement
    assert_equal EnumStateMachine::AllMatcher.instance, @branch.event_requirement
  end
  
  def test_should_use_all_matcher_for_from_state_requirement
    assert_equal EnumStateMachine::AllMatcher.instance, @branch.state_requirements.first[:from]
  end
  
  def test_should_use_all_matcher_for_to_state_requirement
    assert_equal EnumStateMachine::AllMatcher.instance, @branch.state_requirements.first[:to]
  end
  
  def test_should_match_empty_query
    assert @branch.matches?(@object, {})
  end
  
  def test_should_match_non_empty_query
    assert @branch.matches?(@object, :to => :idling, :from => :parked, :on => :ignite)
  end
  
  def test_should_include_all_requirements_in_match
    match = @branch.match(@object, {})
    
    assert_equal @branch.state_requirements.first[:from], match[:from]
    assert_equal @branch.state_requirements.first[:to], match[:to]
    assert_equal @branch.event_requirement, match[:on]
  end
end

class BranchWithFromRequirementTest < MiniTest::Test
  def setup
    @object = Object.new
    @branch = EnumStateMachine::Branch.new(:from => :parked)
  end
  
  def test_should_use_a_whitelist_matcher
    assert_instance_of EnumStateMachine::WhitelistMatcher, @branch.state_requirements.first[:from]
  end
  
  def test_should_match_if_not_specified
    assert @branch.matches?(@object, :to => :idling)
  end
  
  def test_should_match_if_included
    assert @branch.matches?(@object, :from => :parked)
  end
  
  def test_should_not_match_if_not_included
    assert !@branch.matches?(@object, :from => :idling)
  end
  
  def test_should_not_match_if_nil
    assert !@branch.matches?(@object, :from => nil)
  end
  
  def test_should_ignore_to
    assert @branch.matches?(@object, :from => :parked, :to => :idling)
  end
  
  def test_should_ignore_on
    assert @branch.matches?(@object, :from => :parked, :on => :ignite)
  end
  
  def test_should_be_included_in_known_states
    assert_equal [:parked], @branch.known_states
  end
  
  def test_should_include_requirement_in_match
    match = @branch.match(@object, :from => :parked)
    assert_equal @branch.state_requirements.first[:from], match[:from]
  end
end

class BranchWithMultipleFromRequirementsTest < MiniTest::Test
  def setup
    @object = Object.new
    @branch = EnumStateMachine::Branch.new(:from => [:idling, :parked])
  end
  
  def test_should_match_if_included
    assert @branch.matches?(@object, :from => :idling)
  end
  
  def test_should_not_match_if_not_included
    assert !@branch.matches?(@object, :from => :first_gear)
  end
  
  def test_should_be_included_in_known_states
    assert_equal [:idling, :parked], @branch.known_states
  end
end

class BranchWithFromMatcherRequirementTest < MiniTest::Test
  def setup
    @object = Object.new
    @branch = EnumStateMachine::Branch.new(:from => EnumStateMachine::BlacklistMatcher.new([:idling, :parked]))
  end
  
  def test_should_match_if_included
    assert @branch.matches?(@object, :from => :first_gear)
  end
  
  def test_should_not_match_if_not_included
    assert !@branch.matches?(@object, :from => :idling)
  end
  
  def test_include_values_in_known_states
    assert_equal [:idling, :parked], @branch.known_states
  end
end

class BranchWithToRequirementTest < MiniTest::Test
  def setup
    @object = Object.new
    @branch = EnumStateMachine::Branch.new(:to => :idling)
  end
  
  def test_should_use_a_whitelist_matcher
    assert_instance_of EnumStateMachine::WhitelistMatcher, @branch.state_requirements.first[:to]
  end
  
  def test_should_match_if_not_specified
    assert @branch.matches?(@object, :from => :parked)
  end
  
  def test_should_match_if_included
    assert @branch.matches?(@object, :to => :idling)
  end
  
  def test_should_not_match_if_not_included
    assert !@branch.matches?(@object, :to => :parked)
  end
  
  def test_should_not_match_if_nil
    assert !@branch.matches?(@object, :to => nil)
  end
  
  def test_should_ignore_from
    assert @branch.matches?(@object, :to => :idling, :from => :parked)
  end
  
  def test_should_ignore_on
    assert @branch.matches?(@object, :to => :idling, :on => :ignite)
  end
  
  def test_should_be_included_in_known_states
    assert_equal [:idling], @branch.known_states
  end
  
  def test_should_include_requirement_in_match
    match = @branch.match(@object, :to => :idling)
    assert_equal @branch.state_requirements.first[:to], match[:to]
  end
end

class BranchWithMultipleToRequirementsTest < MiniTest::Test
  def setup
    @object = Object.new
    @branch = EnumStateMachine::Branch.new(:to => [:idling, :parked])
  end
  
  def test_should_match_if_included
    assert @branch.matches?(@object, :to => :idling)
  end
  
  def test_should_not_match_if_not_included
    assert !@branch.matches?(@object, :to => :first_gear)
  end
  
  def test_should_be_included_in_known_states
    assert_equal [:idling, :parked], @branch.known_states
  end
end

class BranchWithToMatcherRequirementTest < MiniTest::Test
  def setup
    @object = Object.new
    @branch = EnumStateMachine::Branch.new(:to => EnumStateMachine::BlacklistMatcher.new([:idling, :parked]))
  end
  
  def test_should_match_if_included
    assert @branch.matches?(@object, :to => :first_gear)
  end
  
  def test_should_not_match_if_not_included
    assert !@branch.matches?(@object, :to => :idling)
  end
  
  def test_include_values_in_known_states
    assert_equal [:idling, :parked], @branch.known_states
  end
end

class BranchWithOnRequirementTest < MiniTest::Test
  def setup
    @object = Object.new
    @branch = EnumStateMachine::Branch.new(:on => :ignite)
  end
  
  def test_should_use_a_whitelist_matcher
    assert_instance_of EnumStateMachine::WhitelistMatcher, @branch.event_requirement
  end
  
  def test_should_match_if_not_specified
    assert @branch.matches?(@object, :from => :parked)
  end
  
  def test_should_match_if_included
    assert @branch.matches?(@object, :on => :ignite)
  end
  
  def test_should_not_match_if_not_included
    assert !@branch.matches?(@object, :on => :park)
  end
  
  def test_should_not_match_if_nil
    assert !@branch.matches?(@object, :on => nil)
  end
  
  def test_should_ignore_to
    assert @branch.matches?(@object, :on => :ignite, :to => :parked)
  end
  
  def test_should_ignore_from
    assert @branch.matches?(@object, :on => :ignite, :from => :parked)
  end
  
  def test_should_not_be_included_in_known_states
    assert_equal [], @branch.known_states
  end
  
  def test_should_include_requirement_in_match
    match = @branch.match(@object, :on => :ignite)
    assert_equal @branch.event_requirement, match[:on]
  end
end

class BranchWithMultipleOnRequirementsTest < MiniTest::Test
  def setup
    @object = Object.new
    @branch = EnumStateMachine::Branch.new(:on => [:ignite, :park])
  end
  
  def test_should_match_if_included
    assert @branch.matches?(@object, :on => :ignite)
  end
  
  def test_should_not_match_if_not_included
    assert !@branch.matches?(@object, :on => :shift_up)
  end
end

class BranchWithOnMatcherRequirementTest < MiniTest::Test
  def setup
    @object = Object.new
    @branch = EnumStateMachine::Branch.new(:on => EnumStateMachine::BlacklistMatcher.new([:ignite, :park]))
  end
  
  def test_should_match_if_included
    assert @branch.matches?(@object, :on => :shift_up)
  end
  
  def test_should_not_match_if_not_included
    assert !@branch.matches?(@object, :on => :ignite)
  end
end

class BranchWithExceptFromRequirementTest < MiniTest::Test
  def setup
    @object = Object.new
    @branch = EnumStateMachine::Branch.new(:except_from => :parked)
  end
  
  def test_should_use_a_blacklist_matcher
    assert_instance_of EnumStateMachine::BlacklistMatcher, @branch.state_requirements.first[:from]
  end
  
  def test_should_match_if_not_included
    assert @branch.matches?(@object, :from => :idling)
  end
  
  def test_should_not_match_if_included
    assert !@branch.matches?(@object, :from => :parked)
  end
  
  def test_should_match_if_nil
    assert @branch.matches?(@object, :from => nil)
  end
  
  def test_should_ignore_to
    assert @branch.matches?(@object, :from => :idling, :to => :parked)
  end
  
  def test_should_ignore_on
    assert @branch.matches?(@object, :from => :idling, :on => :ignite)
  end
  
  def test_should_be_included_in_known_states
    assert_equal [:parked], @branch.known_states
  end
end

class BranchWithMultipleExceptFromRequirementsTest < MiniTest::Test
  def setup
    @object = Object.new
    @branch = EnumStateMachine::Branch.new(:except_from => [:idling, :parked])
  end
  
  def test_should_match_if_not_included
    assert @branch.matches?(@object, :from => :first_gear)
  end
  
  def test_should_not_match_if_included
    assert !@branch.matches?(@object, :from => :idling)
  end
  
  def test_should_be_included_in_known_states
    assert_equal [:idling, :parked], @branch.known_states
  end
end

class BranchWithExceptFromMatcherRequirementTest < MiniTest::Test
  def test_should_raise_an_exception
    exception = assert_raises(ArgumentError) {
      EnumStateMachine::Branch.new(:except_from => EnumStateMachine::AllMatcher.instance)
    }
    assert_equal ':except_from option cannot use matchers; use :from instead', exception.message
  end
end

class BranchWithExceptToRequirementTest < MiniTest::Test
  def setup
    @object = Object.new
    @branch = EnumStateMachine::Branch.new(:except_to => :idling)
  end
  
  def test_should_use_a_blacklist_matcher
    assert_instance_of EnumStateMachine::BlacklistMatcher, @branch.state_requirements.first[:to]
  end
  
  def test_should_match_if_not_included
    assert @branch.matches?(@object, :to => :parked)
  end
  
  def test_should_not_match_if_included
    assert !@branch.matches?(@object, :to => :idling)
  end
  
  def test_should_match_if_nil
    assert @branch.matches?(@object, :to => nil)
  end
  
  def test_should_ignore_from
    assert @branch.matches?(@object, :to => :parked, :from => :idling)
  end
  
  def test_should_ignore_on
    assert @branch.matches?(@object, :to => :parked, :on => :ignite)
  end
  
  def test_should_be_included_in_known_states
    assert_equal [:idling], @branch.known_states
  end
end

class BranchWithMultipleExceptToRequirementsTest < MiniTest::Test
  def setup
    @object = Object.new
    @branch = EnumStateMachine::Branch.new(:except_to => [:idling, :parked])
  end
  
  def test_should_match_if_not_included
    assert @branch.matches?(@object, :to => :first_gear)
  end
  
  def test_should_not_match_if_included
    assert !@branch.matches?(@object, :to => :idling)
  end
  
  def test_should_be_included_in_known_states
    assert_equal [:idling, :parked], @branch.known_states
  end
end

class BranchWithExceptToMatcherRequirementTest < MiniTest::Test
  def test_should_raise_an_exception
    exception = assert_raises(ArgumentError) {
      EnumStateMachine::Branch.new(:except_to => EnumStateMachine::AllMatcher.instance)
    }
    assert_equal ':except_to option cannot use matchers; use :to instead', exception.message
  end
end

class BranchWithExceptOnRequirementTest < MiniTest::Test
  def setup
    @object = Object.new
    @branch = EnumStateMachine::Branch.new(:except_on => :ignite)
  end
  
  def test_should_use_a_blacklist_matcher
    assert_instance_of EnumStateMachine::BlacklistMatcher, @branch.event_requirement
  end
  
  def test_should_match_if_not_included
    assert @branch.matches?(@object, :on => :park)
  end
  
  def test_should_not_match_if_included
    assert !@branch.matches?(@object, :on => :ignite)
  end
  
  def test_should_match_if_nil
    assert @branch.matches?(@object, :on => nil)
  end
  
  def test_should_ignore_to
    assert @branch.matches?(@object, :on => :park, :to => :idling)
  end
  
  def test_should_ignore_from
    assert @branch.matches?(@object, :on => :park, :from => :parked)
  end
  
  def test_should_not_be_included_in_known_states
    assert_equal [], @branch.known_states
  end
end

class BranchWithExceptOnMatcherRequirementTest < MiniTest::Test
  def test_should_raise_an_exception
    exception = assert_raises(ArgumentError) {
      EnumStateMachine::Branch.new(:except_on => EnumStateMachine::AllMatcher.instance)
    }
    assert_equal ':except_on option cannot use matchers; use :on instead', exception.message
  end
end

class BranchWithMultipleExceptOnRequirementsTest < MiniTest::Test
  def setup
    @object = Object.new
    @branch = EnumStateMachine::Branch.new(:except_on => [:ignite, :park])
  end
  
  def test_should_match_if_not_included
    assert @branch.matches?(@object, :on => :shift_up)
  end
  
  def test_should_not_match_if_included
    assert !@branch.matches?(@object, :on => :ignite)
  end
end

class BranchWithConflictingFromRequirementsTest < MiniTest::Test
  def test_should_raise_an_exception
    exception = assert_raises(ArgumentError) {
      EnumStateMachine::Branch.new(:from => :parked, :except_from => :parked)
    }
    assert_equal 'Conflicting keys: from, except_from', exception.message
  end
end

class BranchWithConflictingToRequirementsTest < MiniTest::Test
  def test_should_raise_an_exception
    exception = assert_raises(ArgumentError) {
      EnumStateMachine::Branch.new(:to => :idling, :except_to => :idling)
    }
    assert_equal 'Conflicting keys: to, except_to', exception.message
  end
end

class BranchWithConflictingOnRequirementsTest < MiniTest::Test
  def test_should_raise_an_exception
    exception = assert_raises(ArgumentError) {
      EnumStateMachine::Branch.new(:on => :ignite, :except_on => :ignite)
    }
    assert_equal 'Conflicting keys: on, except_on', exception.message
  end
end

class BranchWithDifferentRequirementsTest < MiniTest::Test
  def setup
    @object = Object.new
    @branch = EnumStateMachine::Branch.new(:from => :parked, :to => :idling, :on => :ignite)
  end
  
  def test_should_match_empty_query
    assert @branch.matches?(@object)
  end
  
  def test_should_match_if_all_requirements_match
    assert @branch.matches?(@object, :from => :parked, :to => :idling, :on => :ignite)
  end
  
  def test_should_not_match_if_from_not_included
    assert !@branch.matches?(@object, :from => :idling)
  end
  
  def test_should_not_match_if_to_not_included
    assert !@branch.matches?(@object, :to => :parked)
  end
  
  def test_should_not_match_if_on_not_included
    assert !@branch.matches?(@object, :on => :park)
  end
  
  def test_should_be_nil_if_unmatched
    assert_nil @branch.match(@object, :from => :parked, :to => :idling, :on => :park)
  end
  
  def test_should_include_all_known_states
    assert_equal [:parked, :idling], @branch.known_states
  end
  
  def test_should_not_duplicate_known_statse
    branch = EnumStateMachine::Branch.new(:except_from => :idling, :to => :idling, :on => :ignite)
    assert_equal [:idling], branch.known_states
  end
end

class BranchWithNilRequirementsTest < MiniTest::Test
  def setup
    @object = Object.new
    @branch = EnumStateMachine::Branch.new(:from => nil, :to => nil)
  end
  
  def test_should_match_empty_query
    assert @branch.matches?(@object)
  end
  
  def test_should_match_if_all_requirements_match
    assert @branch.matches?(@object, :from => nil, :to => nil)
  end
  
  def test_should_not_match_if_from_not_included
    assert !@branch.matches?(@object, :from => :parked)
  end
  
  def test_should_not_match_if_to_not_included
    assert !@branch.matches?(@object, :to => :idling)
  end
  
  def test_should_include_all_known_states
    assert_equal [nil], @branch.known_states
  end
end

class BranchWithImplicitRequirementTest < MiniTest::Test
  def setup
    @branch = EnumStateMachine::Branch.new(:parked => :idling, :on => :ignite)
  end
  
  def test_should_create_an_event_requirement
    assert_instance_of EnumStateMachine::WhitelistMatcher, @branch.event_requirement
    assert_equal [:ignite], @branch.event_requirement.values
  end
  
  def test_should_use_a_whitelist_from_matcher
    assert_instance_of EnumStateMachine::WhitelistMatcher, @branch.state_requirements.first[:from]
  end
  
  def test_should_use_a_whitelist_to_matcher
    assert_instance_of EnumStateMachine::WhitelistMatcher, @branch.state_requirements.first[:to]
  end
end

class BranchWithMultipleImplicitRequirementsTest < MiniTest::Test
  def setup
    @object = Object.new
    @branch = EnumStateMachine::Branch.new(:parked => :idling, :idling => :first_gear, :on => :ignite)
  end
  
  def test_should_create_multiple_state_requirements
    assert_equal 2, @branch.state_requirements.length
  end
  
  def test_should_not_match_event_as_state_requirement
    assert !@branch.matches?(@object, :from => :on, :to => :ignite)
  end
  
  def test_should_match_if_from_included_in_any
    assert @branch.matches?(@object, :from => :parked)
    assert @branch.matches?(@object, :from => :idling)
  end
  
  def test_should_not_match_if_from_not_included_in_any
    assert !@branch.matches?(@object, :from => :first_gear)
  end
  
  def test_should_match_if_to_included_in_any
    assert @branch.matches?(@object, :to => :idling)
    assert @branch.matches?(@object, :to => :first_gear)
  end
  
  def test_should_not_match_if_to_not_included_in_any
    assert !@branch.matches?(@object, :to => :parked)
  end
  
  def test_should_match_if_all_options_match
    assert @branch.matches?(@object, :from => :parked, :to => :idling, :on => :ignite)
    assert @branch.matches?(@object, :from => :idling, :to => :first_gear, :on => :ignite)
  end
  
  def test_should_not_match_if_any_options_do_not_match
    assert !@branch.matches?(@object, :from => :parked, :to => :idling, :on => :park)
    assert !@branch.matches?(@object, :from => :parked, :to => :first_gear, :on => :park)
  end
  
  def test_should_include_all_known_states
    assert_equal [:first_gear, :idling, :parked], @branch.known_states.sort_by {|state| state.to_s}
  end
  
  def test_should_not_duplicate_known_statse
    branch = EnumStateMachine::Branch.new(:parked => :idling, :first_gear => :idling)
    assert_equal [:first_gear, :idling, :parked], branch.known_states.sort_by {|state| state.to_s}
  end
end

class BranchWithImplicitFromRequirementMatcherTest < MiniTest::Test
  def setup
    @matcher = EnumStateMachine::BlacklistMatcher.new(:parked)
    @branch = EnumStateMachine::Branch.new(@matcher => :idling)
  end
  
  def test_should_not_convert_from_to_whitelist_matcher
    assert_equal @matcher, @branch.state_requirements.first[:from]
  end
  
  def test_should_convert_to_to_whitelist_matcher
    assert_instance_of EnumStateMachine::WhitelistMatcher, @branch.state_requirements.first[:to]
  end
end

class BranchWithImplicitToRequirementMatcherTest < MiniTest::Test
  def setup
    @matcher = EnumStateMachine::BlacklistMatcher.new(:idling)
    @branch = EnumStateMachine::Branch.new(:parked => @matcher)
  end
  
  def test_should_convert_from_to_whitelist_matcher
    assert_instance_of EnumStateMachine::WhitelistMatcher, @branch.state_requirements.first[:from]
  end
  
  def test_should_not_convert_to_to_whitelist_matcher
    assert_equal @matcher, @branch.state_requirements.first[:to]
  end
end

class BranchWithImplicitAndExplicitRequirementsTest < MiniTest::Test
  def setup
    @branch = EnumStateMachine::Branch.new(:parked => :idling, :from => :parked)
  end
  
  def test_should_create_multiple_requirements
    assert_equal 2, @branch.state_requirements.length
  end
  
  def test_should_create_implicit_requirements_for_implicit_options
    assert(@branch.state_requirements.any? do |state_requirement|
      state_requirement[:from].values == [:parked] && state_requirement[:to].values == [:idling]
    end)
  end
  
  def test_should_create_implicit_requirements_for_explicit_options
    assert(@branch.state_requirements.any? do |state_requirement|
      state_requirement[:from].values == [:from] && state_requirement[:to].values == [:parked]
    end)
  end
end

class BranchWithIfConditionalTest < MiniTest::Test
  def setup
    @object = Object.new
  end
  
  def test_should_have_an_if_condition
    branch = EnumStateMachine::Branch.new(:if => lambda {true})
    refute_nil branch.if_condition
  end
  
  def test_should_match_if_true
    branch = EnumStateMachine::Branch.new(:if => lambda {true})
    assert branch.matches?(@object)
  end
  
  def test_should_not_match_if_false
    branch = EnumStateMachine::Branch.new(:if => lambda {false})
    assert !branch.matches?(@object)
  end
  
  def test_should_be_nil_if_unmatched
    branch = EnumStateMachine::Branch.new(:if => lambda {false})
    assert_nil branch.match(@object)
  end
end

class BranchWithMultipleIfConditionalsTest < MiniTest::Test
  def setup
    @object = Object.new
  end
  
  def test_should_match_if_all_are_true
    branch = EnumStateMachine::Branch.new(:if => [lambda {true}, lambda {true}])
    assert branch.match(@object)
  end
  
  def test_should_not_match_if_any_are_false
    branch = EnumStateMachine::Branch.new(:if => [lambda {true}, lambda {false}])
    assert !branch.match(@object)
    
    branch = EnumStateMachine::Branch.new(:if => [lambda {false}, lambda {true}])
    assert !branch.match(@object)
  end
end

class BranchWithUnlessConditionalTest < MiniTest::Test
  def setup
    @object = Object.new
  end
  
  def test_should_have_an_unless_condition
    branch = EnumStateMachine::Branch.new(:unless => lambda {true})
    refute_nil branch.unless_condition
  end
  
  def test_should_match_if_false
    branch = EnumStateMachine::Branch.new(:unless => lambda {false})
    assert branch.matches?(@object)
  end
  
  def test_should_not_match_if_true
    branch = EnumStateMachine::Branch.new(:unless => lambda {true})
    assert !branch.matches?(@object)
  end
  
  def test_should_be_nil_if_unmatched
    branch = EnumStateMachine::Branch.new(:unless => lambda {true})
    assert_nil branch.match(@object)
  end
end

class BranchWithMultipleUnlessConditionalsTest < MiniTest::Test
  def setup
    @object = Object.new
  end
  
  def test_should_match_if_all_are_false
    branch = EnumStateMachine::Branch.new(:unless => [lambda {false}, lambda {false}])
    assert branch.match(@object)
  end
  
  def test_should_not_match_if_any_are_true
    branch = EnumStateMachine::Branch.new(:unless => [lambda {true}, lambda {false}])
    assert !branch.match(@object)
    
    branch = EnumStateMachine::Branch.new(:unless => [lambda {false}, lambda {true}])
    assert !branch.match(@object)
  end
end

class BranchWithConflictingConditionalsTest < MiniTest::Test
  def setup
    @object = Object.new
  end
  
  def test_should_match_if_if_is_true_and_unless_is_false
    branch = EnumStateMachine::Branch.new(:if => lambda {true}, :unless => lambda {false})
    assert branch.match(@object)
  end
  
  def test_should_not_match_if_if_is_false_and_unless_is_true
    branch = EnumStateMachine::Branch.new(:if => lambda {false}, :unless => lambda {true})
    assert !branch.match(@object)
  end
  
  def test_should_not_match_if_if_is_false_and_unless_is_false
    branch = EnumStateMachine::Branch.new(:if => lambda {false}, :unless => lambda {false})
    assert !branch.match(@object)
  end
  
  def test_should_not_match_if_if_is_true_and_unless_is_true
    branch = EnumStateMachine::Branch.new(:if => lambda {true}, :unless => lambda {true})
    assert !branch.match(@object)
  end
end

class BranchWithoutGuardsTest < MiniTest::Test
  def setup
    @object = Object.new
  end
  
  def test_should_match_if_if_is_false
    branch = EnumStateMachine::Branch.new(:if => lambda {false})
    assert branch.matches?(@object, :guard => false)
  end
  
  def test_should_match_if_if_is_true
    branch = EnumStateMachine::Branch.new(:if => lambda {true})
    assert branch.matches?(@object, :guard => false)
  end
  
  def test_should_match_if_unless_is_false
    branch = EnumStateMachine::Branch.new(:unless => lambda {false})
    assert branch.matches?(@object, :guard => false)
  end
  
  def test_should_match_if_unless_is_true
    branch = EnumStateMachine::Branch.new(:unless => lambda {true})
    assert branch.matches?(@object, :guard => false)
  end
end

begin
  # Load library
  require 'graphviz'
  
  class BranchDrawingTest < MiniTest::Test
    def setup
      @machine = EnumStateMachine::Machine.new(Class.new)
      states = [:parked, :idling]
      
      @graph = EnumStateMachine::Graph.new('test')
      states.each {|state| @graph.add_nodes(state.to_s)}
      
      @branch = EnumStateMachine::Branch.new(:from => :idling, :to => :parked)
      @branch.draw(@graph, :park, states)
      @edge = @graph.get_edge_at_index(0)
    end
    
    def test_should_create_edges
      assert_equal 1, @graph.edge_count
    end
    
    def test_should_use_from_state_from_start_node
      assert_equal 'idling', @edge.node_one(false)
    end
    
    def test_should_use_to_state_for_end_node
      assert_equal 'parked', @edge.node_two(false)
    end
    
    def test_should_use_event_name_as_label
      assert_equal 'park', @edge['label'].to_s.gsub('"', '')
    end
  end
  
  class BranchDrawingWithFromRequirementTest < MiniTest::Test
    def setup
      @machine = EnumStateMachine::Machine.new(Class.new)
      states = [:parked, :idling, :first_gear]
      
      @graph = EnumStateMachine::Graph.new('test')
      states.each {|state| @graph.add_nodes(state.to_s)}
      
      @branch = EnumStateMachine::Branch.new(:from => [:idling, :first_gear], :to => :parked)
      @branch.draw(@graph, :park, states)
    end
    
    def test_should_generate_edges_for_each_valid_from_state
      [:idling, :first_gear].each_with_index do |from_state, index|
        edge = @graph.get_edge_at_index(index)
        assert_equal from_state.to_s, edge.node_one(false)
        assert_equal 'parked', edge.node_two(false)
      end
    end
  end
  
  class BranchDrawingWithExceptFromRequirementTest < MiniTest::Test
    def setup
      @machine = EnumStateMachine::Machine.new(Class.new)
      states = [:parked, :idling, :first_gear]
      
      @graph = EnumStateMachine::Graph.new('test')
      states.each {|state| @graph.add_nodes(state.to_s)}
      
      @branch = EnumStateMachine::Branch.new(:except_from => :parked, :to => :parked)
      @branch.draw(@graph, :park, states)
    end
    
    def test_should_generate_edges_for_each_valid_from_state
      %w(idling first_gear).each_with_index do |from_state, index|
        edge = @graph.get_edge_at_index(index)
        assert_equal from_state, edge.node_one(false)
        assert_equal 'parked', edge.node_two(false)
      end
    end
  end
  
  class BranchDrawingWithoutFromRequirementTest < MiniTest::Test
    def setup
      @machine = EnumStateMachine::Machine.new(Class.new)
      states = [:parked, :idling, :first_gear]
      
      @graph = EnumStateMachine::Graph.new('test')
      states.each {|state| @graph.add_nodes(state.to_s)}
      
      @branch = EnumStateMachine::Branch.new(:to => :parked)
      @branch.draw(@graph, :park, states)
    end
    
    def test_should_generate_edges_for_each_valid_from_state
      %w(parked idling first_gear).each_with_index do |from_state, index|
        edge = @graph.get_edge_at_index(index)
        assert_equal from_state, edge.node_one(false)
        assert_equal 'parked', edge.node_two(false)
      end
    end
  end
  
  class BranchDrawingWithoutToRequirementTest < MiniTest::Test
    def setup
      @machine = EnumStateMachine::Machine.new(Class.new)
      
      graph = EnumStateMachine::Graph.new('test')
      graph.add_nodes('parked')
      
      @branch = EnumStateMachine::Branch.new(:from => :parked)
      @branch.draw(graph, :park, [:parked])
      @edge = graph.get_edge_at_index(0)
    end
    
    def test_should_create_loopback_edge
      assert_equal 'parked', @edge.node_one(false)
      assert_equal 'parked', @edge.node_two(false)
    end
  end
  
  class BranchDrawingWithNilStateTest < MiniTest::Test
    def setup
      @machine = EnumStateMachine::Machine.new(Class.new)
      
      graph = EnumStateMachine::Graph.new('test')
      graph.add_nodes('parked')
      
      @branch = EnumStateMachine::Branch.new(:from => :idling, :to => nil)
      @branch.draw(graph, :park, [nil, :idling])
      @edge = graph.get_edge_at_index(0)
    end
    
    def test_should_generate_edges_for_each_valid_from_state
      assert_equal 'idling', @edge.node_one(false)
      assert_equal 'nil', @edge.node_two(false)
    end
  end
rescue LoadError
  $stderr.puts 'Skipping GraphViz EnumStateMachine::Branch tests. ' \
               '`gem install ruby-graphviz` >= v0.9.17 and try again.'
end unless ENV['TRAVIS']
