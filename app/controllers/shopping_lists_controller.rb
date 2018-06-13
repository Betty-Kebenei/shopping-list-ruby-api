class ShoppingListsController < ApplicationController
    def index
        @shopping_lists = ShoppingList.all
        render json: @shopping_lists
    end

end
