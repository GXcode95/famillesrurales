# frozen_string_literal: true

class ConvertPostEventBodyToActionText < ActiveRecord::Migration[8.2]
  class MigrationPost < ActiveRecord::Base
    self.table_name = "posts"
  end

  class MigrationEvent < ActiveRecord::Base
    self.table_name = "events"
  end

  def up
    rename_column :posts, :body, :legacy_body
    rename_column :events, :body, :legacy_body

    helper = ActionController::Base.helpers

    MigrationPost.reset_column_information
    MigrationPost.find_each do |post|
      text = post.read_attribute(:legacy_body)
      next if text.blank?

      html = helper.simple_format(text.to_s)
      ActionText::RichText.create!(
        record_type: "Post",
        record_id: post.id,
        name: "body",
        body: html
      )
    end

    MigrationEvent.reset_column_information
    MigrationEvent.find_each do |event|
      text = event.read_attribute(:legacy_body)
      next if text.blank?

      html = helper.simple_format(text.to_s)
      ActionText::RichText.create!(
        record_type: "Event",
        record_id: event.id,
        name: "body",
        body: html
      )
    end

    remove_column :posts, :legacy_body, :text
    remove_column :events, :legacy_body, :text
  end

  def down
    add_column :posts, :body, :text
    add_column :events, :body, :text

    ActionText::RichText.where(record_type: "Post", name: "body").find_each do |rt|
      Post.where(id: rt.record_id).update_all(body: rt.to_plain_text)
    end
    ActionText::RichText.where(record_type: "Event", name: "body").find_each do |rt|
      Event.where(id: rt.record_id).update_all(body: rt.to_plain_text)
    end

    ActionText::RichText.where(record_type: %w[Post Event], name: "body").delete_all
  end
end
