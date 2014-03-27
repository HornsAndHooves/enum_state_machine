appraise "default" do
end

# GraphViz
appraise "graphviz_1.0.8" do
  gem "ruby-graphviz", "1.0.8"
end

# ActiveRecord integrations
if RUBY_VERSION > "1.9.2"
  appraise "active_record_4.0.0" do
    gem "sqlite3", "1.3.6"
    gem "activerecord", "4.0.0.beta1", :git => "git://github.com/rails/rails.git", :ref => "92d6dac"
    gem "activerecord-deprecated_finders", "0.0.3"
    gem "protected_attributes", "1.0.0"
    gem "rails-observers", "0.1.1"
  end
end

# ActiveModel integrations
if RUBY_VERSION > "1.9.2"
  appraise "active_model_4.0.0" do
    gem "activemodel", "4.0.0.beta", :git => "git://github.com/rails/rails.git", :ref => "4e286bf"
    gem "rails-observers", "0.1.1"
    gem "protected_attributes", "1.0.0"
  end
end

