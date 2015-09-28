##enum_state_machine
==================

`state_machine` patches to use PowerEnum enums for state values.
It allows you to use an enumerated attribute to track a state machine status.

## Installation:

Add the following to your Gemfile:

```ruby
gem 'enum_state_machine'
```

## Usage:

Before using this you must familiarize yourself with the [PowerEnum](https://github.com/albertosaurus/power_enum_2)
and [state_machine](https://github.com/pluginaweek/state_machine) gems.

Include `EnumStateMachine::StateEnum` in our model. That adds a single method that is used to define an enumerated state attribute:

```ruby
# state_attr is the name of the state variable
# enum_attr is the name of the underlying enumerated attribute
# enum_opts are options to be passed to has_enumerated
has_state_enum(state_attr, enum_attr, enum_opts = {})
```

This is best illustrated with an example. Suppose you have a Grenade model that can have four possible states: stored, armed, kaboom, and fizzle.

```ruby

# Migration

create_enum :grenade_status

create_table :grenades do |t|
  t.references :grenade_statuses
  t.boolean :is_defective

  t.timestamps
end

# Seeds

GrenadeStatus.update_enumerations_model do
  [:unarmed, :armed, :kaboom, :fizzle].each { |name| GrenadeStatus.create! name: name }
end

# Models

class GrenadeStatus < ActiveRecord::Base
  acts_as_enumerated
end

class Grenade < ActiveRecord::Base
  include EnumStateMachine::StateEnum
  has_state_enum :status, :grenade_status, default: :unarmed

  state_machine :status, initial: :unarmed do
    event :pulled_pin do
      transition :unarmed => :armed
    end

    event :thrown do
      # a defective grenade won't explode
      transition :armed => :fizzle, :if => :is_defective?
      # a normal armed one will explode
      transition :armed => :kaboom
      # If you forgot to pull the pin, nothing happens
      transition :unarmed => :unarmed
    end
  end
end
```
