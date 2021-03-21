require "test_helper"
class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:tiburcio)
  end

  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end

  test "unsuccessful edit" do
    log_in_as @user
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params:{ user: {name:'',
      email: 'invalid@test',
      password:         'foo',
      password_confirmation: 'bar'}}
    assert_template 'users/edit'
    assert_select "div.alert", text: 'The form contains 4 errors'
  end

  test "successful edit"do
    log_in_as @user
    get edit_user_path(@user)
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params:{ user: {
                                              name:name,
                                              email: email,
                                              password:         '',
                                              password_confirmation: ''
                                            }}
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal @user.name, name
    assert_equal @user.email, email
  end

  test "successful edit with friendly forwarding"do
    get edit_user_path(@user)
    assert_not_nil session[:forwarding_url]
    log_in_as @user
    assert_redirected_to edit_user_url(@user)
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params:{ user: {
                                              name:name,
                                              email: email,
                                              password:         '',
                                              password_confirmation: ''
                                            }}
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal @user.name, name
    assert_equal @user.email, email
  end

  
  
  
end