class AddPasswordDigestToStaffs < ActiveRecord::Migration[6.0]
  def change
    add_column :staffs, :password_digest, :string
  end
end
