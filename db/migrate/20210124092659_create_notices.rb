class CreateNotices < ActiveRecord::Migration[6.0]
  def change
    create_table :notices do |t|
      t.string :mode
      t.integer :shift_id
      t.integer :staff_id
      t.references :master, null: false, foreign_key: true

      t.timestamps
    end
  end
end
