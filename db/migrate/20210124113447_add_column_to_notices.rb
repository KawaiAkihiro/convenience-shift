class AddColumnToNotices < ActiveRecord::Migration[6.0]
  def change
    add_column :notices, :comment, :string
  end
end
