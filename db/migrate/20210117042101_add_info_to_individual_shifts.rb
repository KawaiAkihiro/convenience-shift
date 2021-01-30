class AddInfoToIndividualShifts < ActiveRecord::Migration[6.0]
  def change
    add_column :individual_shifts, :content, :string
  end
end
