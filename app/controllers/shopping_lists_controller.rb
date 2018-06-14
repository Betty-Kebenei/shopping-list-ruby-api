class ShoppingListsController < ApplicationController
    def index
        @shopping_lists = ShoppingList.all
        render json: @shopping_lists, status: :ok
    end

    def show
        @shopping_list = ShoppingList.find_by(id: params[:id])

        response = if @shopping_list 
            { status: :ok , json: { shopping_list: @shopping_list }.to_json }
        else
            { status: :not_found }
        end

        render response
    end

end
