require 'rails_helper'

RSpec.describe 'Merchant Searches' do
  it 'searches by partial name parameter' do
    merchant_1 = Merchant.create!(name: 'EMPloyee')
    merchant_2 = Merchant.create!(name: 'Emporer')
    merchant_3 = Merchant.create!(name: 'The temp')
    merchant_4 = Merchant.create!(name: 'Williams Tavern')
    merchant_5 = Merchant.create!(name: "Emigo's")

    get '/api/v1/merchants/find_all?name=emp'

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(merchants[:data].count).to eq 3

    merchants[:data].each do |merchant|
      expect(merchant[:attributes][:name]).to_not include(merchant_4.name)
      expect(merchant[:attributes][:name]).to_not include(merchant_5.name)
    end
  end

  it 'returns an error if name parameter is not filled in at least partially' do
    merchant_1 = Merchant.create!(name: 'EMPloyee')
    merchant_2 = Merchant.create!(name: 'Emporer')
    merchant_3 = Merchant.create!(name: 'The temp')
    merchant_4 = Merchant.create!(name: 'Williams Tavern')
    merchant_5 = Merchant.create!(name: "Emigo's")

    get '/api/v1/merchants/find_all?name='

    expect(response.status).to eq 400
    expect(response.message).to eq('Bad Request')
  end

  it 'returns an empty array if no merchants are found' do
    merchant_1 = Merchant.create!(name: 'EMPloyee')
    merchant_2 = Merchant.create!(name: 'Emporer')
    merchant_3 = Merchant.create!(name: 'The temp')
    merchant_4 = Merchant.create!(name: 'Williams Tavern')
    merchant_5 = Merchant.create!(name: "Emigo's")

    get '/api/v1/merchants/find_all?name=z'

    parsed = JSON.parse(response.body, symbolize_names: true)
    found = parsed[:data]

    expect(response.status).to eq 404
    expect(found).to eq([])
  end

  it 'searches by partial name parameter and returns the first merchant found' do
    merchant_1 = Merchant.create!(name: 'EMPloyee')
    merchant_2 = Merchant.create!(name: 'Emporer')
    merchant_3 = Merchant.create!(name: 'The temp')
    merchant_4 = Merchant.create!(name: 'Williams Tavern')
    merchant_5 = Merchant.create!(name: "Emigo's")

    get '/api/v1/merchants/find?name=emp'

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(response.status).to eq 200
    expect(merchant.count).to eq 1

    expect(merchant[:data][:attributes][:name]).to eq(merchant_1.name)
  end

  it 'returns an empty hash when no name matches the parameter' do
    merchant_1 = Merchant.create!(name: 'EMPloyee')
    merchant_2 = Merchant.create!(name: 'Emporer')
    merchant_3 = Merchant.create!(name: 'The temp')
    merchant_4 = Merchant.create!(name: 'Williams Tavern')
    merchant_5 = Merchant.create!(name: "Emigo's")

    get '/api/v1/merchants/find?name=z'

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq 404
    expect(merchant.count).to eq 1

    expect(merchant[:data]).to eq({})
  end
end