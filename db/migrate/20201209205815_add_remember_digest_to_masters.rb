class AddRememberDigestToMasters < ActiveRecord::Migration[6.0]
  def change
    add_column :masters, :remember_digest, :string
  end
end
