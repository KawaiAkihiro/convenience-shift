class AddMasterIdToIndividualShifts < ActiveRecord::Migration[6.0]
  def change
    add_column :individual_shifts, :master_id, :integer
  end
end
