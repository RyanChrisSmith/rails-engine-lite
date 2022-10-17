require 'rails_helper'

RSpec.describe Item, type: :model do
  it { should validate_presence_of :name}
  it { should validate_presence_of :description}
  it { should validate_numericality_of :unit_price}

  it { should belong_to :merchant}
end
