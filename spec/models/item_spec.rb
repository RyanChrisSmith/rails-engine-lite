require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to :merchant}
    it { should have_many :invoice_items}
    it { should have_many(:invoices).through(:invoice_items)}
  end
  describe 'class methods do' do
    before :each do
      @merchant = create(:merchant)
      @item_1 = Item.create!(name: 'Turing school', description: 'stuff in the basement', unit_price: 22.99, merchant: @merchant)
      @item_2 = Item.create!(name: 'Necklace', description: 'This silver chime will bring you cheer!', unit_price: 33.11, merchant: @merchant)
      @item_3 = Item.create!(name: "Johns record", description: 'best music you ever heard', unit_price: 1.11, merchant: @merchant)
    end

    it 'can search for the first item matching name OR description parameter' do
      expect(Item.search('ring')).to eq(@item_1)
    end

    it 'can search by minumum price' do
      expect(Item.price_search({min_price: 1.00})).to eq([@item_3, @item_2, @item_1])
      expect(Item.price_search({min_price: 22.11})).to eq([@item_2, @item_1])
    end

    it 'can search by maximum price' do
      expect(Item.price_search({max_price: 25.00})).to eq([@item_3, @item_1])
      expect(Item.price_search({max_price: 22.99})).to eq([@item_3, @item_1])
      expect(Item.price_search({max_price: 22.98})).to eq([@item_3])
    end

    it 'can search by a price range' do
      expect(Item.price_search({min_price: 1.00, max_price: 23.00})).to eq([@item_3, @item_1])
      expect(Item.price_search({min_price: 22.99, max_price: 35.00})).to eq([@item_2, @item_1])
    end

  end
end
