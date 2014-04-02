{:en => {
  :activemodel => {
    :errors => {
      :messages => {
        :invalid => EnumStateMachine::Machine.default_messages[:invalid],
        :invalid_event => EnumStateMachine::Machine.default_messages[:invalid_event] % ['%{state}'],
        :invalid_transition => EnumStateMachine::Machine.default_messages[:invalid_transition] % ['%{event}']
      }
    }
  }
}}
