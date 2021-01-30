class AddDeletableToIndividualShift < ActiveRecord::Migration[6.0]
  def change
    add_column :individual_shifts, :deletable, :boolean, default: false, null: false
  end
end
