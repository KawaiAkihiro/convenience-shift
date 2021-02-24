class CreateIndividualShifts < ActiveRecord::Migration[6.0]
  def change
    create_table :individual_shifts do |t|
      t.datetime :start_time
      t.datetime :finish_time
      t.references :staff, null: false, foreign_key: true
      t.boolean :confirm
      t.boolean :Temporary
      t.boolean :deletable

      t.timestamps
    end
  end
end
