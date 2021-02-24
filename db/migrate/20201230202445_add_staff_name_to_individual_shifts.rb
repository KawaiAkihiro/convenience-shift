class AddStaffNameToIndividualShifts < ActiveRecord::Migration[6.0]
  def change
    add_column :individual_shifts, :staff_name, :string
  end
end
