require 'rails_helper'

RSpec.describe Merchant, type: :model do
  it { should have_many :items}
  it { should have_many :invoices}
  it { should have_many(:invoice_items).through(:items)}
  it { should have_many(:transactions).through(:invoices)}
  it { should have_many(:customers).through(:invoices)}

  describe 'class methods' do
    it 'can search for all by partial name fragment ' do
      merchant_1 = Merchant.create!(name: 'EMPloyee')
      merchant_2 = Merchant.create!(name: 'Emporer')
      merchant_3 = Merchant.create!(name: 'The temp')
      merchant_4 = Merchant.create!(name: 'Williams Tavern')
      merchant_5 = Merchant.create!(name: "Emigo's")

      expect(Merchant.search_all('emp')).to eq([merchant_1,merchant_2,merchant_3])
    end
  end
end
