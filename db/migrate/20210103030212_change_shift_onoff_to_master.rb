class ChangeShiftOnoffToMaster < ActiveRecord::Migration[6.0]
  def change
    change_column :masters, :shift_onoff, :boolean, default: false, null: false
  end
end
