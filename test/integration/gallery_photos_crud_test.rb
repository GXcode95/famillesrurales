# frozen_string_literal: true

require "test_helper"

class GalleryPhotosCrudTest < ActionDispatch::IntegrationTest
  test "index is public" do
    get gallery_photos_path
    assert_response :success
  end

  test "guest cannot create or destroy gallery photo" do
    user = create_user(email: "owner@example.com")
    photo = user.gallery_photos.build
    photo.image.attach(
      io: StringIO.new("fake image bytes"),
      filename: "demo.png",
      content_type: "image/png"
    )
    photo.save!

    upload = fixture_file_upload("test/fixtures/files/test.png", "image/png")
    post gallery_photos_path, params: { gallery_photo: { tag_list: "fete", images: [upload] } }
    assert_redirected_to new_user_session_path

    delete gallery_photo_path(photo)
    assert_redirected_to new_user_session_path
  end

  test "signed in user can create and destroy gallery photo" do
    sign_in create_user
    upload = fixture_file_upload("test/fixtures/files/test.png", "image/png")

    assert_difference("GalleryPhoto.count", 1) do
      post gallery_photos_path, params: { gallery_photo: { tag_list: "atelier", images: [upload] } }
    end
    assert_redirected_to gallery_photos_path

    photo = GalleryPhoto.order(:id).last
    assert_difference("GalleryPhoto.count", -1) do
      delete gallery_photo_path(photo)
    end
    assert_redirected_to gallery_photos_path
  end
end
