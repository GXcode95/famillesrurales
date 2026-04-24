# frozen_string_literal: true

require "test_helper"

class StaffsCrudTest < ActionDispatch::IntegrationTest
  test "index is public" do
    get staffs_path
    assert_response :success
  end

  test "guest cannot create update or destroy staff" do
    staff = Staff.create!(name: "Alice", email: "alice@example.com")

    post staffs_path, params: { staff: { name: "Bob", email: "bob@example.com" } }
    assert_redirected_to new_user_session_path

    patch staff_path(staff), params: { staff: { name: "Alice Martin" } }
    assert_redirected_to new_user_session_path

    delete staff_path(staff)
    assert_redirected_to new_user_session_path
  end

  test "signed in user can create update and destroy staff" do
    sign_in create_user

    assert_difference("Staff.count", 1) do
      post staffs_path, params: { staff: { name: "Claire", email: "claire@example.com" } }
    end
    assert_redirected_to staffs_path
    staff = Staff.order(:id).last

    patch staff_path(staff), params: { staff: { job: "Animation" } }
    assert_redirected_to staffs_path
    assert_equal "Animation", staff.reload.job

    assert_difference("Staff.count", -1) do
      delete staff_path(staff)
    end
    assert_redirected_to staffs_path
  end
end
