class AddModeToIndividualShifts < ActiveRecord::Migration[6.0]
  def change
    add_column :individual_shifts, :mode, :string
  end
end
