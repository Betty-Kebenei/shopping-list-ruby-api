class ShoppingListsController < ApplicationController
    before_action :find_list_by_id, only: [:show, :update, :destroy]
    def index
        @shopping_lists = ShoppingList.all
        render json: @shopping_lists, status: :ok
    end

    def show
        render json: @shopping_list
    end

    def create 
        @shopping_list = ShoppingList.create(shopping_list_params)

        response = if @shopping_list.valid?
            { status: :created , json: { shopping_list: @shopping_list }.to_json }
        else
            { status: :unprocessable_entity , json: @shopping_list.errors.messages.to_json }
        end

        render response

    end

    def destroy
        @shopping_list.destroy
    end

    private

    def shopping_list_params
        params.permit(:title, :created_by)
    end

    def find_list_by_id
        @shopping_list = ShoppingList.find_by(id: params[:id])

        response = if @shopping_list.class == NilClass
            { status: :not_found }
        end

        render response

    end

end
