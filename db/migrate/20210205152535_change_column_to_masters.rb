class ChangeColumnToMasters < ActiveRecord::Migration[6.0]
  def change
    change_column :masters, :onoff_email,   :boolean, default: true, null: true
  end
end
