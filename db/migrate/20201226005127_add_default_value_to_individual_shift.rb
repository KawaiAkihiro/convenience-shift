class AddDefaultValueToIndividualShift < ActiveRecord::Migration[6.0]
  def change
    change_column :individual_shifts, :confirm,   :boolean, default: false, null: false
    change_column :individual_shifts, :Temporary, :boolean, default: true, null: true
  end
end
