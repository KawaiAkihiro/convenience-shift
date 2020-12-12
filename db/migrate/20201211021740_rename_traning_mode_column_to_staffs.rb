class RenameTraningModeColumnToStaffs < ActiveRecord::Migration[6.0]
  def change
    rename_column :staffs, :traning_mode, :training_mode
  end
end
