# frozen_string_literal: true

class AddEndDateToActivities < ActiveRecord::Migration[8.2]
  def change
    add_column :activities, :end_date, :date
  end
end
