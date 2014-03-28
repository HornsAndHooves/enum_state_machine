namespace :enum_state_machine do
  desc 'Draws state machines using GraphViz (options: CLASS=User,Vehicle; FILE=user.rb,vehicle.rb [not required in Rails]; FONT=Arial; FORMAT=png; ORIENTATION=portrait; HUMAN_NAMES=true'
  task :draw do
    # Build drawing options
    options = {}
    options[:file] = ENV['FILE'] if ENV['FILE']
    options[:path] = ENV['TARGET'] if ENV['TARGET']
    options[:format] = ENV['FORMAT'] if ENV['FORMAT']
    options[:font] = ENV['FONT'] if ENV['FONT']
    options[:orientation] = ENV['ORIENTATION'] if ENV['ORIENTATION']
    options[:human_names] = ENV['HUMAN_NAMES'] == 'true' if ENV['HUMAN_NAMES']
    
    if defined?(Rails)
      puts "Files are automatically loaded in Rails; ignoring FILE option" if options.delete(:file)
      Rake::Task['environment'].invoke
    else
      # Load the library
      $:.unshift(File.dirname(__FILE__) + '/..')
      require 'enum_state_machine'
    end
    
    EnumStateMachine::Machine.draw(ENV['CLASS'], options)
  end
end
