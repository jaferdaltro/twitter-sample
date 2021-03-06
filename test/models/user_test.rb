require "test_helper"

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user = User.new(name: 'User User', email:'email@ex.com',
                      password: 'foobar', password_confirmation: 'foobar')
  end
  
  test "user should be valid" do
    assert @user.valid?
  end

  test "name should be valid" do
    @user.name = ""
    assert_not @user.valid?
  end
 
  test "email should be valid" do
    @user.email = ""
    assert_not @user.valid?
  end

  test "name shouldn't be too long" do 
    @user.name = "a" * 51
    assert_not @user.valid?
  end
 
  test "email shouldn't be too long" do 
    @user.email = "a" * 256 + "@example.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp
                          alice+bob@boz.cn]
    valid_addresses.each do |v_a|
      @user.email = v_a
      assert @user.valid?, "#{v_a.inspect} should be valid"
    end               
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org 
                            user.name@example.foo@bar_baz foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |i_a|
      @user.email = i_a
      assert_not @user.valid?, "#{i_a.inspect} should be invalid" 
    end
  end
  
  test "email addresses should be unique" do
    u_duplicate = @user.dup
    @user.save
    assert_not u_duplicate.valid?
  end

  test "email addresses should be saved as lower-case" do
    mixed_email_case = 'KdkOll@gllk.com'
    @user.email = mixed_email_case
    @user.save
    assert_equal mixed_email_case.downcase, @user.reload.email
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?  
  end

  test "password should have a mimimal length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?  
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end

  test "associated microposts should be destroyed" do
    @user.save 
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference 'Micropost.count' , -1 do
      @user.destroy
    end
  end
  test "should follow and unfollow a user" do
    michael = users(:michael)
    archer  = users(:archer)
    assert_not michael.following?(archer)
    michael.follow(archer)
    assert michael.following?(archer)
    assert archer.followers.include?(michael)
    michael.unfollow(archer)
    assert_not michael.following?(archer)
    # Users can't follow themselves.
    michael.follow(michael)
    assert_not michael.following?(michael)
  end
  test "feed should have the right posts" do
    michael = users(:michael)
    archer  = users(:archer)
    lana    = users(:lana)
    # Posts from followed user
    lana.microposts.each do |post_following|
      assert michael.feed.include?(post_following)
    end
    # Self-posts for user with followers
    michael.microposts.each do |post_self|
      assert michael.feed.include?(post_self)
    end
    # Self-posts for user with no followers
    archer.microposts.each do |post_self|
      assert archer.feed.include?(post_self)
    end
    # Posts from unfollowed user
    archer.microposts.each do |post_unfollowed|
      assert_not michael.feed.include?(post_unfollowed)
    end
  end

end
