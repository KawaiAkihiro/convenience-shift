class ChangeModelIndividualShifts < ActiveRecord::Migration[6.0]
  def change
    change_column :individual_shifts, :finish_time, :datetime
  end
end
