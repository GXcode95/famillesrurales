# frozen_string_literal: true

require "test_helper"

class CommentsCrudTest < ActionDispatch::IntegrationTest
  test "guest can create comment on post and event" do
    post_record = Post.create!(title: "Actu", body: "Texte")
    event = Event.create!(name: "Marché", body: "Infos")

    assert_difference("Comment.count", 1) do
      post post_comments_path(post_record), params: { comment: { author: "Jean", content: "Bravo !" } }
    end
    assert_redirected_to posts_path(anchor: "post-#{post_record.id}")

    assert_difference("Comment.count", 1) do
      post event_comments_path(event), params: { comment: { author: "Lea", content: "Super" } }
    end
    assert_redirected_to event_path(event)
  end

  test "guest cannot destroy comment" do
    post_record = Post.create!(title: "Actu", body: "Texte")
    comment = post_record.comments.create!(author: "Nina", content: "Top")

    delete post_comment_path(post_record, comment)
    assert_redirected_to new_user_session_path
  end

  test "signed in user can destroy comment" do
    sign_in create_user
    post_record = Post.create!(title: "Actu", body: "Texte")
    comment = post_record.comments.create!(author: "Nina", content: "Top")

    assert_difference("Comment.count", -1) do
      delete post_comment_path(post_record, comment)
    end
    assert_redirected_to posts_path(anchor: "post-#{post_record.id}")
  end
end
