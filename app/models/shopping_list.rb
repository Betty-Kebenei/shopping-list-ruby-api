class ShoppingList < ApplicationRecord
    has_many :shopping_items, dependent: :destroy

    validates_presence_of :title, :created_by
    validates_length_of :title, :minimum => 3
    validates :title, uniqueness: { case_sensitive: false, message: "That title is already taken!"}
end
