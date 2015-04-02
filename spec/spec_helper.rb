
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment",__FILE__)
require 'rspec/rails'
require 'factory_girl_rails'
require 'database_cleaner'
require 'shoulda/matchers'
require 'cancan/matchers'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|


  config.include ControllerMacros, type: :controller
  config.include FactoryGirl::Syntax::Methods
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
  config.include Devise::TestHelpers, :type => :controller
  config.infer_spec_type_from_file_location!
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end



