require 'rails_helper'

describe "Items API" do

  it 'can get a list of a specific merchant items' do
    merchant = create(:merchant)
    items = create_list(:item, 10, merchant: merchant)

    get "/api/v1/merchants/#{merchant.id}/items"

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)
    expect(items[:data].count).to eq 10

    items[:data].each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)

      expect(item).to have_key(:type)
      expect(item[:type]).to eq('item')

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)

      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_a(Integer)
    end
  end

  it 'sends a list of items' do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    items_1 = create_list(:item, 10, merchant: merchant_1)
    items_2 = create_list(:item, 10, merchant: merchant_2)

    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)
    expect(items[:data].count).to eq 20
  end

  it 'can get a specific item' do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    items_1 = create_list(:item, 10, merchant: merchant_1)
    items_2 = create_list(:item, 10, merchant: merchant_2)
    item = Item.first

    get "/api/v1/items/#{item.id}"

    expect(response).to be_successful

    item_returned = JSON.parse(response.body, symbolize_names: true)

    expect(item_returned.count).to eq 1

    expect(item_returned[:data]).to have_key(:id)
    expect(item_returned[:data][:id]).to eq(item.id.to_s)

    expect(item_returned[:data]).to have_key(:type)
    expect(item_returned[:data][:type]).to eq('item')

    expect(item_returned[:data]).to have_key(:attributes)
    expect(item_returned[:data][:attributes]).to have_key(:name)
    expect(item_returned[:data][:attributes][:name]).to be_a(String)

    expect(item_returned[:data][:attributes]).to have_key(:description)
    expect(item_returned[:data][:attributes][:description]).to be_a(String)

    expect(item_returned[:data][:attributes]).to have_key(:unit_price)
    expect(item_returned[:data][:attributes][:unit_price]).to be_a(Float)

    expect(item_returned[:data][:attributes]).to have_key(:merchant_id)
    expect(item_returned[:data][:attributes][:merchant_id]).to be_an(Integer)
  end

  it 'can create a new item' do
    merchant = create(:merchant)
    item_params = ({"name": "Dragon's Milk", "description": "great for digestions", "unit_price": 12.66, "merchant_id": merchant.id})
    headers = {"CONTENT_TYPE" => "application/json"}

    post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)
    new_item = Item.last

    expect(response).to be_successful
    expect(new_item.name).to eq("Dragon's Milk")
    expect(new_item.description).to eq('great for digestions')
    expect(new_item.unit_price).to eq 12.66
    expect(new_item.merchant_id).to eq(merchant.id)
  end

  # xit 'can update an existing item' do
  #   id = create(:item).id
  #   previous_name = Item.last.name
  #   item_params = { name: "Dragons Milk" }
  #   headers = {"{CONTENT_TYPE" => "application/json"}

  #   patch api_v1_item_path(id), headers: headers, params: JSON.generate(item: item_params)
  #   item = Item.find_by(id: id)

  #   expect(response).to be_successful

  #   expect(item.name).to_not eq(previous_name)
  #   expect(item.name).to eq('Dragons Milk')
  # end
end