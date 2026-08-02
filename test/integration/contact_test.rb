# frozen_string_literal: true

require "test_helper"

class ContactTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  test "contact form is public" do
    get contact_path
    assert_response :success
  end

  test "valid contact form enqueues email and redirects" do
    assert_enqueued_emails 1 do
      post contact_path, params: {
        contact_form: {
          name: "Marie",
          email: "marie@example.com",
          subject: "Inscription",
          message: "Bonjour, je souhaite des infos."
        }
      }
    end

    assert_redirected_to contact_path
    follow_redirect!
    assert_match "Votre message a bien été envoyé", response.body
  end

  test "invalid contact form is rejected without email" do
    assert_no_enqueued_emails do
      post contact_path, params: {
        contact_form: {
          name: "",
          email: "pas-un-email",
          subject: "",
          message: ""
        }
      }
    end

    assert_response :unprocessable_entity
  end
end
