class CreateStaffs < ActiveRecord::Migration[8.2]
  def change
    create_table :staffs do |t|
      t.string :name
      t.string :job
      t.string :phone
      t.string :email
      t.timestamps
    end
  end
end
