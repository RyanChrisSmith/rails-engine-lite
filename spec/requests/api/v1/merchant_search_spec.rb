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
end