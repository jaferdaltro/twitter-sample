require "test_helper"

class UserShowTest < ActionDispatch::IntegrationTest

  def setup
    @inactive = users(:inactive)
    @active = users(:tiburcio)
  end
  
  test "should redirect when user not activated" do
    get user_path(@inactive)
    assert_response :redirect
    assert_redirected_to root_url
  end
  
  test "should display user when activated" do
    get user_path(@active)
    assert_response :success
    assert_template 'users/show'
  end
end
