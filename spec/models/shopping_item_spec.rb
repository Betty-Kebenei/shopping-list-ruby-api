require 'rails_helper'

RSpec.describe ShoppingItem, type: :model do
  it { should belong_to(:shopping_list) }
  it { should validate_presence_of(:item_name) }
end
