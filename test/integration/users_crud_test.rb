# frozen_string_literal: true

require "test_helper"

class UsersCrudTest < ActionDispatch::IntegrationTest
  test "guest cannot list or create users" do
    get users_path
    assert_redirected_to new_user_session_path

    get new_user_path
    assert_redirected_to new_user_session_path

    assert_no_difference("User.count") do
      post users_path, params: {
        user: {
          email: "nouveau@example.com",
          password: "Password123!",
          password_confirmation: "Password123!"
        }
      }
    end
    assert_redirected_to new_user_session_path
  end

  test "signed in user can list and create users" do
    sign_in create_user

    get users_path
    assert_response :success

    get new_user_path
    assert_response :success

    assert_difference("User.count", 1) do
      post users_path, params: {
        user: {
          email: "nouveau@example.com",
          password: "Password123!",
          password_confirmation: "Password123!"
        }
      }
    end
    assert_redirected_to users_path
    follow_redirect!
    assert_match "nouveau@example.com", response.body
  end

  test "create rejects invalid user" do
    sign_in create_user

    assert_no_difference("User.count") do
      post users_path, params: {
        user: {
          email: "pas-un-email",
          password: "123",
          password_confirmation: "456"
        }
      }
    end
    assert_response :unprocessable_entity
  end
end
