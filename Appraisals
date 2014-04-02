appraise "default" do
end

# GraphViz
appraise "graphviz_1.0.9" do
  gem "ruby-graphviz", "~> 1.0.9"
end

# ActiveRecord integrations
if RUBY_VERSION > "1.9.2"
  appraise "active_record_4.0.4" do
    gem "sqlite3", "~> 1.3.9"
    gem "activerecord", "~> 4.0.4"
    gem "activerecord-deprecated_finders", "~> 1.0.3"
    gem "protected_attributes", "~> 1.0.7"
    gem "rails-observers", "~> 0.1.2"
  end
end

# ActiveModel integrations
if RUBY_VERSION > "1.9.2"
  appraise "active_model_4.0.4" do
    gem "activemodel", "~> 4.0.4"
    gem "rails-observers", "~> 0.1.2"
    gem "protected_attributes", "~> 1.0.7"
  end
end

