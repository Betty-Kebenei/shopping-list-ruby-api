class CreateShoppingLists < ActiveRecord::Migration[5.2]
  def change
    create_table :shopping_lists do |t|
      t.string :title
      t.string :created_by

      t.timestamps
    end
  end
end
