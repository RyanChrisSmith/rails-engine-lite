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

  it 'returns null as an object when there are no matches for the partial search' do
    merchant = create(:merchant)
    item_2 = Item.create!(name: 'Necklace', description: 'This silver chime will bring you cheer!', unit_price: 33.11, merchant: merchant)
    item_1 = Item.create!(name: 'Turing school', description: 'stuff in the basement', unit_price: 22.99, merchant: merchant)
    item_3 = Item.create!(name: "Johns record", description: 'best music you ever heard', unit_price: 1.11, merchant: merchant)


    get '/api/v1/items/find?name=z'

    expect(response.status).to eq 200
    parsed = JSON.parse(response.body, symbolize_names: true)

    expect(parsed).to be_a(Hash)
    expect(parsed[:data]).to eq({})
  end

  it 'can find the first item above a minimum price point' do
    merchant = create(:merchant)
    item_1 = Item.create!(name: 'Turing school', description: 'stuff in the basement', unit_price: 22.99, merchant: merchant)
    item_2 = Item.create!(name: 'Necklace', description: 'This silver chime will bring you cheer!', unit_price: 55.11, merchant: merchant)
    item_3 = Item.create!(name: "Johns record", description: 'best music you ever heard', unit_price: 61.11, merchant: merchant)

    get '/api/v1/items/find?min_price=50'

    item_returned = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(item_returned.count).to eq 1
    expect(item_returned[:data][:attributes][:name]).to eq(item_3.name)
  end

  it 'can find the first item below a maximum price point' do
    merchant = create(:merchant)
    item_1 = Item.create!(name: 'Turing school', description: 'stuff in the basement', unit_price: 22.99, merchant: merchant)
    item_2 = Item.create!(name: 'Necklace', description: 'This silver chime will bring you cheer!', unit_price: 95.11, merchant: merchant)
    item_3 = Item.create!(name: "Johns record", description: 'best music you ever heard', unit_price: 161.11, merchant: merchant)

    get '/api/v1/items/find?max_price=150'

    item_returned = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(item_returned.count).to eq 1
    expect(item_returned[:data][:attributes][:name]).to eq(item_2.name)
  end

  it 'can find items between a max and min price point' do
    merchant = create(:merchant)
    item_1 = Item.create!(name: 'Turing school', description: 'stuff in the basement', unit_price: 22.99, merchant: merchant)
    item_2 = Item.create!(name: 'Necklace', description: 'This silver chime will bring you cheer!', unit_price: 95.11, merchant: merchant)
    item_3 = Item.create!(name: "Johns record", description: 'best music you ever heard', unit_price: 161.11, merchant: merchant)

    get '/api/v1/items/find?max_price=150&min_price=50'

    item_returned = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(item_returned.count).to eq 1

    expect(item_returned[:data][:attributes][:name]).to include(item_2.name)
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

  it 'will return null as an object if the min price is so big nothing matches' do
    merchant = create(:merchant)
    item_1 = Item.create!(name: 'Turing school', description: 'stuff in the basement', unit_price: 22.99, merchant: merchant)
    item_2 = Item.create!(name: 'Necklace', description: 'This silver chime will bring you cheer!', unit_price: 55.11, merchant: merchant)
    item_3 = Item.create!(name: "Johns record", description: 'best music you ever heard', unit_price: 61.11, merchant: merchant)

    get '/api/v1/items/find?min_price=500000000'
    returned = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq 200
    expect(returned).to be_a(Hash)
    expect(returned[:data]).to eq({})
  end

  it 'cannot search by negative numbers' do
    merchant = create(:merchant)
    item_1 = Item.create!(name: 'Turing school', description: 'stuff in the basement', unit_price: 22.99, merchant: merchant)
    item_2 = Item.create!(name: 'Necklace', description: 'This silver chime will bring you cheer!', unit_price: 55.11, merchant: merchant)
    item_3 = Item.create!(name: "Johns record", description: 'best music you ever heard', unit_price: 61.11, merchant: merchant)

    get '/api/v1/items/find?min_price=-5'
    returned = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq 400
    expect(returned).to have_key(:errors)
    expect(returned[:errors]).to have_key(:details)
    expect(returned[:errors][:details]).to eq("Price search cannot use a negative number")
  end
end