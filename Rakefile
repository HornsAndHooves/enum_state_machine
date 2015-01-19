require 'rubygems'
require 'bundler'
Bundler.setup

require 'rake'
require 'rake/testtask'

desc 'Default: run all tests.'
task :default => :test

desc "Test enum_state_machine."
Rake::TestTask.new(:test) do |t|
  integration = %w(active_model active_record).detect do |name|
    Bundler.default_gemfile.to_s.include?(name)
  end
  
  t.libs << 'lib'
  t.test_files = integration ? Dir["test/unit/integrations/#{integration}_test.rb"] : Dir['test/{functional,unit}/*_test.rb'] + ['test/unit/integrations/base_test.rb']
  t.verbose = true
  t.warning = true if ENV['WARNINGS']
end

load File.dirname(__FILE__) + '/lib/tasks/enum_state_machine.rake'

Bundler::GemHelper.install_tasks
