class RemoveColumnToIndividualShifts < ActiveRecord::Migration[6.0]
  def change
    remove_column :individual_shifts, :content
  end
end
