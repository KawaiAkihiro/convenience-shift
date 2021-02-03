class AddEmailToMasters < ActiveRecord::Migration[6.0]
  def change
    add_column :masters, :email, :string
  end
end
