class CreateComments < ActiveRecord::Migration[8.2]
  def change
    create_table :comments do |t|
      t.references :post, null: false, foreign_key: true
      t.references :author, null: false
      t.timestamps
    end
  end
end
