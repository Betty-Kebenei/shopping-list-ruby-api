class CreateShoppingItems < ActiveRecord::Migration[5.2]
  def change
    create_table :shopping_items do |t|
      t.string :item_name
      t.float :quantity
      t.string :units
      t.float :price
      t.string :currency
      t.boolean :bought
      t.references :shopping_list, foreign_key: true

      t.timestamps
    end
  end
end
