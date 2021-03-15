ENV['RAILS_ENV'] ||= 'test'
require_relative "../config/environment"
require "rails/test_help"
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  include ApplicationHelper  
  # include SessionsHelper -> NÃO FUNCIONA NA UNIDADE 9
  # Add more helper methods to be used by all tests here...

  #return true if test user is logged in.
  def is_logged_in?
    !session[:user_id].nil?
  end
  

end
