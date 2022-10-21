require 'rails_helper'

RSpec.describe Customer do 
  describe 'relationships' do 
    it {should have_many :invoices}
    it {should have_many(:items).through(:invoices)}
    it {should have_many(:transactions).through(:invoices)}
    it {should have_many(:merchants).through(:items)}
  end

  describe 'validations' do
    it { should validate_presence_of :first_name}
    it { should validate_presence_of :last_name}
  end
end