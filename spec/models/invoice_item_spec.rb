require 'rails_helper'

RSpec.describe InvoiceItem do
  describe 'relationships' do
    it { should belong_to :invoice}
    it { should belong_to :item}
    it { should have_many(:transactions).through(:invoice)}
  end

  describe 'validations' do
    it { should validate_numericality_of :quantity}
    it { should validate_numericality_of :unit_price}
  end
end