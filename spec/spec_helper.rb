
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment",__FILE__)
require 'rspec/rails'
require 'rubygems'
require 'factory_girl_rails'
require 'database_cleaner'

RSpec.configure do |config|

  config.include FactoryGirl::Syntax::Methods
  config.before(:suite) do
   DatabaseCleaner.strategy = :truncation
  end
  config.before(:each) do
   DatabaseCleaner.start
  end
  config.after(:each) do
   DatabaseCleaner.clean
  end
end


RSpec.configure do |config|
  config.include Devise::TestHelpers, :type => :controller
#  config.extend ControllerMacros, :type => :controller
end


RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
