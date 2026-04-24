# frozen_string_literal: true

require "test_helper"

class PostsCrudTest < ActionDispatch::IntegrationTest
  test "index is public" do
    get posts_path
    assert_response :success
  end

  test "guest cannot create update or destroy post" do
    post_record = Post.create!(title: "Actu", body: "Contenu")

    post posts_path, params: { post: { title: "Nouvelle", body: "Texte" } }
    assert_redirected_to new_user_session_path

    patch post_path(post_record), params: { post: { title: "Actu modifiée" } }
    assert_redirected_to new_user_session_path

    delete post_path(post_record)
    assert_redirected_to new_user_session_path
  end

  test "signed in user can create update and destroy post" do
    sign_in create_user

    assert_difference("Post.count", 1) do
      post posts_path, params: { post: { title: "Atelier d'été", body: "Programme complet" } }
    end
    assert_redirected_to posts_path(anchor: "post-#{Post.order(:id).last.id}")
    post_record = Post.order(:id).last

    patch post_path(post_record), params: { post: { title: "Atelier d'été 2026", body: "Programme final" } }
    assert_redirected_to posts_path(anchor: "post-#{post_record.id}")
    assert_equal "Atelier d'été 2026", post_record.reload.title

    assert_difference("Post.count", -1) do
      delete post_path(post_record)
    end
    assert_redirected_to posts_path
  end
end
