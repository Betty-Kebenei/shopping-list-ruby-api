require "rails_helper"

RSpec.describe "ShoppingItems API", type: :request do
    let!(:shopping_list) {create(:shopping_list)}
    let(:shopping_list_id) {shopping_list.id}
    let!(:shopping_items) {create_list(:shopping_item, 10, shopping_list_id: shopping_list.id)}
    let(:shopping_item_id) {shopping_items.first.id}

    describe "GET /shopping_lists/:shopping_list_id/shopping_items" do
        before { get "/shopping_lists/#{shopping_list_id}/shopping_items" }
        
        context "when shopping items exist" do
            it "returns shopping_items" do
                expect(json).not_to be_empty
                expect(json.size).to eq(10)
                expect(response).to have_http_status(200)
            end
        end
        context "when shopping items don't exist" do
            let!(:shopping_items) {create_list(:shopping_items, 0)}

            it "returns 404 error" do
                expect(response).to have_http_status(204)
            end
        end
    end 
        
    describe "GET /shopping_lists/:shopping_list_id/shopping_items/:id" do
        before { get "/shopping_lists/#{shopping_list_id}/shopping_items/#{shopping_item_id}" }

        context "when shopping_item exists" do
            it "returns a 200 status code" do
                expect(response).to have_http_status(200)
            end
            it "returns a json object" do
                expect(json).not_to be_empty
            end
        end

        context "when a shopping_item does not exist" do
            let(:shopping_item_id) { 20 }

            it "returns a 404 status code" do
                expect(response).to have_http_status(404)
            end
        end
    end

    describe "POST /shopping_lists/:shopping_list_id/shopping_items" do

        context "when data is valid" do
            let(:data) { {
                item_name: "oranges",
                quantity: "10.0",
                units: "bags",
                price: "3000",
                currency: "KSH",
                bought: "false"
            } } 
            before { post "/shopping_lists/#{shopping_list_id}/shopping_items", params: data }

            it "creates a shopping_item" do
                expect(json).not_to be_empty
                expect(json["shopping_item"]["item_name"]).to eq("oranges")
                expect(json["shopping_item"]["quantity"]).to eq("10.0")
                expect(json["shopping_item"]["units"]).to eq("bags")
                expect(json["shopping_item"]["price"]).to eq("3000")
                expect(json["shopping_item"]["currency"]).to eq("KSH")
                expect(response).to have_http_status(201)
            end
        end

        context "when item_name is missing" do
            let(:data) { {
                item_name: "",
                quantity: "10.0",
                units: "bags",
                price: "3000",
                currency: "KSH",
                bought: "false"
            } }
            before { post "/shopping_lists/#{shopping_list_id}/shopping_items", params: data }

            it "returns a 422 error" do
                expect(response).to have_http_status(422)
            end
            it "returns a validation error" do
                expect(json["item_name"]).to include(/is too short/)
            end
        end

    end

    describe "PUT /shopping_lists/:shopping_list_id/shopping_items/:id" do

        context "when data is valid" do
            let(:data) { {item_name: "oranges"} } 
            before { put "/shopping_lists/#{shopping_list_id}/shopping_items/#{shopping_item_id}", params: data }

            it "creates a shopping_item" do
                expect(json).not_to be_empty
                expect(json["shopping_item"]["item_name"]).to eq("oranges")
                expect(response).to have_http_status(200)
            end
        end

        context "when item_name is missing" do
            let(:data) { {item_name: ""} }
            before { put "/shopping_lists/#{shopping_list_id}/shopping_items/#{shopping_item_id}", params: data }

            it "returns a 422 error" do
                expect(response).to have_http_status(422)
            end
            it "returns a validation error" do
                expect(json["item_name"]).to include(/is too short/)
            end
        end
    end

    describe "DELETE /shopping_lists/:shopping_list_id/shopping_items/:id" do

        context "when deleting shopping item that exists" do
            before { delete "/shopping_lists/#{shopping_list_id}/shopping_items/#{shopping_item_id}" }
            it "deletes successfully" do
                expect(response).to have_http_status(200)
            end
        end

        context "when deleting a shopping item that does not exist" do
            let(:shopping_item_id) { 20 }
            before { delete "/shopping_lists/#{shopping_list_id}/shopping_items/#{shopping_item_id}" }

            it "returns an error" do
                expect(response).to have_http_status(404)
            end
        end

    end

end
