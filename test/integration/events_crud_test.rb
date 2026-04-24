# frozen_string_literal: true

require "test_helper"

class EventsCrudTest < ActionDispatch::IntegrationTest
  test "index and show are public" do
    event = Event.create!(name: "Fête locale", body: "Description")

    get events_path
    assert_response :success

    get event_path(event)
    assert_response :success
  end

  test "guest cannot create update or destroy event" do
    event = Event.create!(name: "Sortie", body: "Texte")

    post events_path, params: { event: { name: "Nouveau", body: "Infos" } }
    assert_redirected_to new_user_session_path

    patch event_path(event), params: { event: { name: "Sortie scolaire" } }
    assert_redirected_to new_user_session_path

    delete event_path(event)
    assert_redirected_to new_user_session_path
  end

  test "signed in user can create update and destroy event" do
    sign_in create_user

    assert_difference("Event.count", 1) do
      post events_path, params: { event: { name: "Forum des associations", body: "Stand et échanges" } }
    end
    event = Event.order(:id).last
    assert_redirected_to event_path(event)

    patch event_path(event), params: { event: { name: "Forum familles", body: "Rencontre annuelle" } }
    assert_redirected_to event_path(event)
    assert_equal "Forum familles", event.reload.name

    assert_difference("Event.count", -1) do
      delete event_path(event)
    end
    assert_redirected_to events_path
  end
end
