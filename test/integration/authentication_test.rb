# frozen_string_literal: true

require "test_helper"

class AuthenticationTest < ActionDispatch::IntegrationTest
  test "user can sign in with valid credentials" do
    user = create_user(email: "admin@example.com", password: "Password123!")

    post user_session_path, params: { user: { email: user.email, password: "Password123!" } }
    assert_response :redirect

    get users_path
    assert_response :success
  end

  test "sign in with invalid credentials fails" do
    user = create_user(email: "admin@example.com", password: "Password123!")

    post user_session_path, params: { user: { email: user.email, password: "wrong-password" } }

    get users_path
    assert_redirected_to new_user_session_path
  end

  test "signed in user can sign out" do
    sign_in create_user

    delete destroy_user_session_path
    assert_response :redirect

    get users_path
    assert_redirected_to new_user_session_path
  end
end
