class AddStaffNumberToMasters < ActiveRecord::Migration[6.0]
  def change
    add_column :masters, :staff_number, :integer
  end
end
