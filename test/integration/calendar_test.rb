# frozen_string_literal: true

require "test_helper"

class CalendarTest < ActionDispatch::IntegrationTest
  test "calendar shows events for the requested month" do
    in_month = Event.create!(
      name: "Fête du village",
      body: "Programme",
      date: Time.zone.local(2026, 8, 15, 14, 0, 0)
    )
    Event.create!(
      name: "Hors mois",
      body: "Autre",
      date: Time.zone.local(2026, 9, 1, 10, 0, 0)
    )

    get calendar_path, params: { month: 8, year: 2026 }
    assert_response :success
    assert_select "ul li a[title=?]", in_month.name
    assert_select "ul li a[title=?]", "Hors mois", count: 0
  end
end
