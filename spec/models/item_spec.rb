require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to :merchant}
    it { should have_many :invoice_items}
    it { should have_many(:invoices).through(:invoice_items)}
  end

  describe 'validations' do
    it { should validate_presence_of :name}
    it { should validate_presence_of :description}
    it { should validate_presence_of :unit_price}
  end
  describe 'class methods do' do
    it 'can search for the first item matching name OR description parameter' do
      merchant = create(:merchant)
      item_1 = Item.create!(name: 'Turing school', description: 'stuff in the basement', unit_price: 22.99, merchant: merchant)
      item_2 = Item.create!(name: 'Necklace', description: 'This silver chime will bring you cheer!', unit_price: 33.11, merchant: merchant)
      item_3 = Item.create!(name: "Johns record", description: 'best music you ever heard', unit_price: 1.11, merchant: merchant)

      expect(Item.search('ring')).to eq(item_1)
    end

  end
end
