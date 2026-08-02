# frozen_string_literal: true

require "test_helper"

class HomeTest < ActionDispatch::IntegrationTest
  test "home page is public and lists latest posts" do
    Post.create!(title: "Ancienne actu", body: "Texte")
    latest = Post.create!(title: "Dernière actu", body: "Contenu récent")

    get root_path
    assert_response :success
    assert_match latest.title, response.body
  end
end
