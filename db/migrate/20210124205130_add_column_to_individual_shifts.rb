class AddColumnToIndividualShifts < ActiveRecord::Migration[6.0]
  def change
    add_column :individual_shifts, :plan, :string
  end
end
