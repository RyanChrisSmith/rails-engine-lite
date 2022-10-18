require 'rails_helper'

RSpec.describe 'Item Searches' do
  it 'searches for an item by partial name, returning the first item with either name or description with parameter' do
    merchant = create(:merchant)
    item_1 = Item.create!(name: 'Turing school', description: 'stuff in the basement', unit_price: 22.99, merchant: merchant)
    item_2 = Item.create!(name: 'Necklace', description: 'This silver chime will bring you cheer!', unit_price: 33.11, merchant: merchant)
    item_3 = Item.create!(name: "Johns record", description: 'best music you ever heard', unit_price: 1.11, merchant: merchant)


    get '/api/v1/items/find?name=ring'

    expect(response).to be_successful
    item_returned = JSON.parse(response.body, symbolize_names: true)

    expect(item_returned[:data][:attributes][:name]).to eq(item_1.name)
  end

  it 'searches for an item by partial name, returning the FIRST item with either name or description with parameter' do
    merchant = create(:merchant)
    item_2 = Item.create!(name: 'Necklace', description: 'This silver chime will bring you cheer!', unit_price: 33.11, merchant: merchant)
    item_1 = Item.create!(name: 'Turing school', description: 'stuff in the basement', unit_price: 22.99, merchant: merchant)
    item_3 = Item.create!(name: "Johns record", description: 'best music you ever heard', unit_price: 1.11, merchant: merchant)


    get '/api/v1/items/find?name=ring'

    expect(response).to be_successful
    item_returned = JSON.parse(response.body, symbolize_names: true)

    expect(item_returned[:data][:attributes][:name]).to eq(item_2.name)
  end

  it 'can find items above a minimum price point' do
    merchant = create(:merchant)
    item_1 = Item.create!(name: 'Turing school', description: 'stuff in the basement', unit_price: 22.99, merchant: merchant)
    item_2 = Item.create!(name: 'Necklace', description: 'This silver chime will bring you cheer!', unit_price: 55.11, merchant: merchant)
    item_3 = Item.create!(name: "Johns record", description: 'best music you ever heard', unit_price: 61.11, merchant: merchant)

    get '/api/v1/items/find?min_price=50'

    items_returned = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(items_returned[:data].count).to eq 2

    items_returned[:data].each do |item_returned|
      expect(item_returned[:attributes][:name]).to_not include(item_1.name)
    end
  end

  it 'will error when searching by price and name at the same time' do
    merchant = create(:merchant)
    item_1 = Item.create!(name: 'Turing school', description: 'stuff in the basement', unit_price: 22.99, merchant: merchant)
    item_2 = Item.create!(name: 'Necklace', description: 'This silver chime will bring you cheer!', unit_price: 55.11, merchant: merchant)
    item_3 = Item.create!(name: "Johns record", description: 'best music you ever heard', unit_price: 61.11, merchant: merchant)

    get '/api/v1/items/find?name=ent&max_price=56.00'
    parsed = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(400)
    expect(parsed).to have_key(:errors)
    expect(parsed[:errors][:details]).to eq("Must search by name OR price")
  end
end