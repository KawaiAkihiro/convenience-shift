class RenameTimeColumnToIndividualShifts < ActiveRecord::Migration[6.0]
  def change
    rename_column :individual_shifts, :start_time, :start
    rename_column :individual_shifts, :finish_time, :finish
  end
end
