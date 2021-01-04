class RemoveDeletableToIndividualShift < ActiveRecord::Migration[6.0]
  def change
    remove_column :individual_shifts, :deletable
  end
end
