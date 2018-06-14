require "rails_helper"

RSpec.describe "ShoppingList API", type: :request do
    let!(:shopping_lists) {create_list(:shopping_list, 10)}
    let(:shopping_list_id) {shopping_lists.first.id}

    describe "GET /shopping_lists" do
        before { get "/shopping_lists" }

        it "returns shopping_lists" do
            expect(json).not_to be_empty
            expect(json.size).to eq(10)
            expect(response).to have_http_status(200)
        end
    end

    describe "GET /shopping_lists/:id" do
        before { get "/shopping_lists/#{shopping_list_id}" }

        context "when shopping_list exists" do
            it "returns a shopping_list if exists" do
                expect(json).not_to be_empty
                expect(response).to have_http_status(200)
            end
        end

        context "when does not shopping_list exist" do
            let(:shopping_list_id) { 20 }
            it "returns no shopping_list if it does not exists" do
                expect(response).to have_http_status(404)
            end
        end
    end

    describe "POST /shopping_lists" do

        context "when data is valid" do
            let(:data) { { title: "Food stuffs", created_by: "1" } }
            before { post "/shopping_lists", params: data }

            it "creates a shopping_list" do
                expect(json).not_to be_empty
                expect(json["title"]).to eq("Food stuffs")
                expect(json["created_by"]).to eq("1")
                expect(response).to have_http_status(201)
            end
        end

        context "when title data is missing" do
            let(:data) { { created_by: "1" } }
            before { post "/shopping_lists", params: data }

            it "fails creating a shopping_list without a title " do
                expect(response.body).to match(/Validation failed: Title can"t be blank/)
                expect(response).to have_http_status(400)
            end
        end

        context "when created_by data is missing" do
            let(:data) { { title: "Food stuffs" } }
            before { post "/shopping_lists", params: data }

            it "fails creating a shopping_list without a created_by " do
                expect(response.body).to match(/Validation failed: Created by can"t be blank/)
                expect(response).to have_http_status(400)
            end
        end

        context "when creating duplicate shopping lists" do
            let(:data) { { title: "Food stuffs", created_by: "1" } }
            before { post "/shopping_lists", params: data }

            it "creates a shopping_list" do
                expect(json).not_to be_empty
                expect(json["title"]).to eq("Food stuffs")
                expect(json["created_by"]).to eq("1")
                expect(response).to have_http_status(201)
            end

            let(:data) { { title: "Food stuffs", created_by: "1" } }
            before { post "/shopping_lists", params: data }

            it "returns duplication error message" do
                expect(response.body).to match(/Validation failed: No duplicates allowed/)
                expect(response).to have_http_status(409)
            end
        end

        context "length of the title is less than 3" do
            let(:data) { { title: "Fo", created_by: "1" } }
            before { post "/shopping_lists", params: data }

            it "returns an error stating minimum length with 409 status " do
                expect(response.body).to match(/Validation failed: Minimum length should be 3/)
                expect(response).to have_http_status(409)
            end
        end

        context "title is just made up of integers and no letters" do
            let(:data) { { title: "1111", created_by: "1" } }
            before { post "/shopping_lists", params: data }

            it "returns an error stating valid format with 409 status " do
                expect(response.body).to match(/Validation failed: A title must have atleast one letter/)
                expect(response).to have_http_status(409)
            end
        end
    end

    describe "PUT /shopping_lists/:id" do
        
        context "with valid data" do
            let(:data) { { title: 'Fruits' } }
            before { put "/shopping_lists/#{shopping_list_id}", params: data }

            it "updates a shopping_list if exists" do
                expect(json["title"]).to eq("Fruits")
                expect(response).to have_http_status(200)
            end
        end

        context "when update is done with duplication" do
            let(:first_data) { { title: "Food stuffs", created_by: "1" } }
            before { post "/shopping_lists", params: first_data }

            let(:second_data) { { title: "House stuffs", created_by: "1" } }
            before { post "/shopping_lists", params: second_data }

            let(:update_data) { { title: "Food stuffs" } }
            let(:shopping_list_id) { 2 }
            before { put "/shopping_lists/#{shopping_list_id}", params: update_data }

            it "returns an error that a shopping list with that title of an already" do
                expect(response.body).to match(/Validation failed: duplicate data/)
                expect(response).to have_http_status(409)
            end
        end

        context "length of the title is less than 3" do
            let(:data) { { title: "Fo" } }
            before { put "/shopping_lists/#{shopping_list_id}", params: data }

            it "returns an error stating minimum length with 409 status " do
                expect(response.body).to match(/Validation failed: Minimum length should be 3/)
                expect(response).to have_http_status(409)
            end
        end

        context "title is just made up of integers and no letters" do
            let(:data) { { title: "1111" } }
            before { put "/shopping_lists/#{shopping_list_id}", params: data }

            it "returns an error stating valid format with 409 status " do
                expect(response.body).to match(/Validation failed: A title must have atleast one letter/)
                expect(response).to have_http_status(409)
            end
        end
    end

    describe "DELETE /shopping_lists/:id" do

        context "when deleting an existing shopping list" do
            before { delete "/shopping_lists/#{shopping_list_id}" }
            it "deletes successfully" do
                expect(response).to have_http_status(204)
            end
        end

        context "when deleting an existing shopping list" do
            let(:shopping_list_id) { 20 }
            before { delete "/shopping_lists/#{shopping_list_id}" }
            it "returns an error" do
                expect(response.body).to match(/No list to delete/)
                expect(response).to have_http_status(404)
            end
        end

    end

end