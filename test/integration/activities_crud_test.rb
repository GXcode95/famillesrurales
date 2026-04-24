# frozen_string_literal: true

require "test_helper"

class ActivitiesCrudTest < ActionDispatch::IntegrationTest
  test "index and show are public" do
    category = Category.create!(name: "Sport")
    activity = Activity.create!(name: "Foot", category:)

    get activities_path
    assert_response :success

    get activity_path(activity)
    assert_response :success
  end

  test "guest cannot create update or destroy activity" do
    category = Category.create!(name: "Culture")
    activity = Activity.create!(name: "Théâtre", category:)

    post activities_path, params: { activity: { name: "Chant", category_id: category.id } }
    assert_redirected_to new_user_session_path

    patch activity_path(activity), params: { activity: { name: "Théâtre enfant" } }
    assert_redirected_to new_user_session_path

    delete activity_path(activity)
    assert_redirected_to new_user_session_path
  end

  test "signed in user can create update and destroy activity" do
    sign_in create_user
    category = Category.create!(name: "Loisirs")

    assert_difference("Activity.count", 1) do
      post activities_path, params: { activity: { name: "Échecs", category_id: category.id } }
    end
    activity = Activity.order(:id).last
    assert_redirected_to activity_path(activity)

    patch activity_path(activity), params: { activity: { name: "Échecs débutants", category_id: category.id } }
    assert_redirected_to activity_path(activity)
    assert_equal "Échecs débutants", activity.reload.name

    assert_difference("Activity.count", -1) do
      delete activity_path(activity)
    end
    assert_redirected_to activities_path
  end
end
