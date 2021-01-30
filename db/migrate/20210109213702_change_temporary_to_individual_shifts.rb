class ChangeTemporaryToIndividualShifts < ActiveRecord::Migration[6.0]
  def change
    change_column :individual_shifts, :Temporary, :boolean, default: false, null: false
  end
end
