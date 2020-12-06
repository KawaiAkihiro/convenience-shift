class AddPasswordDigestToMasters < ActiveRecord::Migration[6.0]
  def change
    add_column :masters, :password_digest, :string
  end
end
