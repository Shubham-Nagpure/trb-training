class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.boolean :self_pickup
      t.float :price

      t.timestamps
    end
  end
end
