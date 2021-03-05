require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  def setup
    @base = "Ruby on Rails Sample App"
  end

  
  test "should get home" do
    get root_url
    assert_response :success
    assert_select "title", @base       
  end

  test "should get help" do
    get help_url
    assert_response :success
    assert_select "title", "Help | #{@base}"
  end
  
  test "should get about" do
    get about_url
    assert_response :success
    assert_select "title", "About | #{@base}"
  end

  test "should get contact" do
    get contact_url
    assert_response :success
    assert_select "title", "Contact | #{@base}"
  end
  
  
end
