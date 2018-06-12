class ShoppingItem < ApplicationRecord
  belongs_to :shopping_list

  validates_presence_of :item_name
end
