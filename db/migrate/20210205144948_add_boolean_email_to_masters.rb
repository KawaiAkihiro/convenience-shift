class AddBooleanEmailToMasters < ActiveRecord::Migration[6.0]
  def change
    add_column :masters, :onoff_email, :boolean
  end
end
