require 'rails_helper'

RSpec.describe ShoppingList, type: :model do
  it { should have_many(:shopping_items).dependent(:destroy) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:created_by) }
  # it { should validate_length_of(:title).is_at_least(3)
  #   .with_message(/The minimum length of the title of your shopping list should be 3/) }
end
