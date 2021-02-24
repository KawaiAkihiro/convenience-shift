class CreateMasters < ActiveRecord::Migration[6.0]
  def change
    create_table :masters do |t|
      t.string :store_name
      t.string :user_name

      t.timestamps
    end
  end
end
