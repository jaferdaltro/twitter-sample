require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:tiburcio)
  end
  

  test "login with invalid information" do
    #visite login path
    get login_path
    #verifique se a nova sessão renderiza corretamente
    assert_template 'sessions/new'
    #Insirira as informações no login com dados invàlidos
    post login_path, params: {session: {email: '', passowrd: ''}}
    #verifique se a sessão de login é renderizada
    assert_template 'sessions/new'
    #verifique se aparece uma flash mensage
    assert_not flash.empty?
    #visite outra página (tipo a home page)
    get root_path
    #verifique se a flash message ainda aparece
    assert flash.empty?
  end

  test "login with valid information" do
    # visite a pagina de login
    get login_path
    # Insira informações de login válidas
    post login_path, params: {session:{email: @user.email, password: "password"}}
    #tenha certeza que foi pra página
    assert_redirected_to @user
    #visitar a página redirecionada
    follow_redirect!
    #ver se o template é 'users/show
    assert_template 'users/show'
    #ver se o link de login desapareceu - assert_select
    assert_select "a[href=?]", login_path, count: 0
    #verificar se o link de logout apareceu 
    assert_select "a[href=?]", logout_path
    #verificar se o link de perfil apareceu
    assert_select "a[href=?]", user_path(@user)
  
  end

  test "login with correct user and incorrect password" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: {session:{email: @user.email, password: "wrong"}}
    assert_not is_logged_in?
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid information followed by logout" do
    # visite a pagina de login
    get login_path
    # Insira informações de login válidas
    post login_path, params: {session:{email: @user.email, password: "password"}}
    assert is_logged_in?
    #tenha certeza que foi pra página
    assert_redirected_to @user
    #visitar a página redirecionada
    follow_redirect!
    #ver se o template é 'users/show
    assert_template 'users/show'
    #ver se o link de login desapareceu - assert_select
    assert_select "a[href=?]", login_path, count: 0
    #verificar se o link de logout apareceu 
    assert_select "a[href=?]", logout_path
    #verificar se o link de perfil apareceu
    assert_select "a[href=?]", user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    #try to logout in a second window
    assert_redirected_to root_url
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
    
  
  end

  test "authenticate? should return false for a user with nil digest"do
    assert_not @user.authenticated?('')
  end

  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    # assert_not cookies[:remember_token].blank?
    assert_equal cookies['remember_token'], assigns(:user).remember_token
  end

  test "login without remembering" do
    #login to set the cookie
    log_in_as(@user, remember_me: '1')
    #login again to see if the cookie is deleted
    log_in_as(@user, remember_me: '0')
    assert cookies[:remember_token].blank?
  end

 
end
