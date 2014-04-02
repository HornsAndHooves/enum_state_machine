$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'enum_state_machine/version'

Gem::Specification.new do |s|
  s.name              = "enum_state_machine"
  s.version           = EnumStateMachine::VERSION
  s.authors           = [""]
  s.email             = ""
  s.homepage          = ""
  s.description       = "Adds support for creating enum  state machines for attributes on any Ruby class"
  s.summary           = "Enum State machines for attributes"
  s.require_paths     = ["lib"]
  ignores             = File.read(".gitignore").split.map {|i| i.sub(/\/$/, "/*").sub(/^[^\/]/, "**/\\0")}
  s.files             = (Dir[".*"] + Dir["**/*"]).select {|f| File.file?(f) && !ignores.any? {|i| File.fnmatch(i, "/#{f}")}}
  s.test_files        = s.files.grep(/^test\//)
  s.rdoc_options      = %w(--line-numbers --inline-source --title enum_state_machine --main README.md)
  s.extra_rdoc_files  = %w(README.md CHANGELOG.md LICENSE)

  s.add_dependency("power_enum", "~> 2.4")
  
  s.add_development_dependency("rake")
  s.add_development_dependency("simplecov")
  s.add_development_dependency("appraisal", "~> 0.5.0")
end
