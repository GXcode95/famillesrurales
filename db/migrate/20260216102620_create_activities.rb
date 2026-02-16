class CreateActivities < ActiveRecord::Migration[8.2]
  def change
    create_table :activities do |t|
      t.references :categories, null: false, foreign_key: true
      
      t.string :name
      t.string :manager_name
      t.string :manager_phone
      t.string :manager_email
      t.string :teacher_name
      t.float :pricing
      t.text :info

      t.date :start_date
      t.time :start_time
      t.time :end_time
      
      
      t.timestamps
    end
  end
end
