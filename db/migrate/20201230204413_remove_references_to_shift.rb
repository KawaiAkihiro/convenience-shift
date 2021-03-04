class RemoveReferencesToShift < ActiveRecord::Migration[6.0]
  def down
    remove_column :individual_shifts, :staff_name, :string
    remove_index :individual_shifts, :master_id
    remove_column :individual_shifts, :master_id
  end
end
