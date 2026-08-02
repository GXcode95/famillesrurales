# frozen_string_literal: true

require "test_helper"

class ActivityTest < ActiveSupport::TestCase
  setup do
    @category = Category.create!(name: "cat-#{SecureRandom.hex(4)}")
  end

  test "rejects end_date before start_date" do
    activity = Activity.new(
      name: "Atelier",
      category: @category,
      start_date: Date.new(2026, 8, 10),
      end_date: Date.new(2026, 8, 9)
    )

    assert_not activity.valid?
    assert_includes activity.errors[:end_date], "doit être le même jour ou après la date de début"
  end

  test "allows end_date on or after start_date" do
    same_day = Activity.new(
      name: "Atelier",
      category: @category,
      start_date: Date.new(2026, 8, 10),
      end_date: Date.new(2026, 8, 10)
    )
    assert same_day.valid?

    later = Activity.new(
      name: "Stage",
      category: @category,
      start_date: Date.new(2026, 8, 10),
      end_date: Date.new(2026, 8, 12)
    )
    assert later.valid?
  end
end
