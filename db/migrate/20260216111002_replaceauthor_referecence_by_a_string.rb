class ReplaceauthorReferecenceByAString < ActiveRecord::Migration[8.2]
  def change
    remove_reference :comments, :author
    add_column :comments, :author, :string
    add_column :comments, :content, :text
  end
end
