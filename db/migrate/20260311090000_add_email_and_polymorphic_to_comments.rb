# frozen_string_literal: true

class AddEmailAndPolymorphicToComments < ActiveRecord::Migration[8.2]
  def up
    add_column :comments, :email, :string
    add_column :comments, :commentable_type, :string
    add_column :comments, :commentable_id, :bigint

    # Migrer les commentaires existants vers Post
    execute <<-SQL.squish
      UPDATE comments SET commentable_type = 'Post', commentable_id = post_id
    SQL

    change_column_null :comments, :commentable_type, false
    change_column_null :comments, :commentable_id, false
    add_index :comments, [:commentable_type, :commentable_id]

    remove_foreign_key :comments, :posts
    remove_column :comments, :post_id
  end

  def down
    add_column :comments, :post_id, :bigint
    add_foreign_key :comments, :posts

    execute <<-SQL.squish
      UPDATE comments SET post_id = commentable_id WHERE commentable_type = 'Post'
    SQL

    remove_index :comments, [:commentable_type, :commentable_id]
    remove_column :comments, :commentable_type
    remove_column :comments, :commentable_id
    remove_column :comments, :email
  end
end
