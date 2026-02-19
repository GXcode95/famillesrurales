# frozen_string_literal: true

class AddBodyToEvents < ActiveRecord::Migration[8.2]
  def change
    add_column :events, :body, :text
  end
end
