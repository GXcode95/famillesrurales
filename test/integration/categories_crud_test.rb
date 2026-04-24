# frozen_string_literal: true

require "test_helper"

class CategoriesCrudTest < ActionDispatch::IntegrationTest
  test "index is public" do
    get categories_path
    assert_response :success
  end

  test "guest cannot create update or destroy category" do
    category = Category.create!(name: "Culture")

    post categories_path, params: { category: { name: "Sport" } }
    assert_redirected_to new_user_session_path

    patch category_path(category), params: { category: { name: "Danse" } }
    assert_redirected_to new_user_session_path

    delete category_path(category)
    assert_redirected_to new_user_session_path
  end

  test "signed in user can create and update category" do
    sign_in create_user

    assert_difference("Category.count", 1) do
      post categories_path, params: { category: { name: "Musique" } }
    end
    assert_redirected_to categories_path

    category = Category.find_by!(name: "Musique")
    patch category_path(category), params: { category: { name: "Piano" } }
    assert_redirected_to categories_path
    assert_equal "Piano", category.reload.name
  end

  test "signed in user can delete category and its activities" do
    sign_in create_user
    category = Category.create!(name: "Ref Category")
    Activity.create!(name: "Atelier", category:)

    assert_difference("Category.count", -1) do
      assert_difference("Activity.count", -1) do
        delete category_path(category)
      end
    end

    assert_redirected_to categories_path
  end
end
