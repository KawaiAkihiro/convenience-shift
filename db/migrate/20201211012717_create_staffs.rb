class CreateStaffs < ActiveRecord::Migration[6.0]
  def change
    create_table :staffs do |t|
      t.string :staff_name
      t.integer :staff_number
      t.boolean :traning_mode
      t.references :master, null: false, foreign_key: true

      t.timestamps
    end
    add_index :staffs, [:master_id, :created_at]
  end
end
