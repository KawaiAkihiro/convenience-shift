class AddShiftOnoffToMaster < ActiveRecord::Migration[6.0]
  def change
    add_column :masters, :shift_onoff, :boolean
  end
end
