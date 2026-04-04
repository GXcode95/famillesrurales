# frozen_string_literal: true

class MigrateActionTextBodyToColumnsForTinymce < ActiveRecord::Migration[8.2]
  def up
    add_column :posts, :body, :text unless column_exists?(:posts, :body)
    add_column :events, :body, :text unless column_exists?(:events, :body)

    say_with_time "Copie du HTML Action Text vers posts.body" do
      ActionText::RichText.where(record_type: "Post", name: "body").find_each do |rt|
        html = rt.read_attribute(:body)
        html = html.respond_to?(:to_s) ? html.to_s : ""
        next if html.blank?

        sql = ActiveRecord::Base.sanitize_sql_array([ "UPDATE posts SET body = ? WHERE id = ?", html, rt.record_id ])
        execute(sql)
      end
    end

    say_with_time "Copie du HTML Action Text vers events.body" do
      ActionText::RichText.where(record_type: "Event", name: "body").find_each do |rt|
        html = rt.read_attribute(:body)
        html = html.respond_to?(:to_s) ? html.to_s : ""
        next if html.blank?

        sql = ActiveRecord::Base.sanitize_sql_array([ "UPDATE events SET body = ? WHERE id = ?", html, rt.record_id ])
        execute(sql)
      end
    end

    ActionText::RichText.where(record_type: %w[Post Event], name: "body").delete_all
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
