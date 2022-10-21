class InvoiceItem < ApplicationRecord
  validates_numericality_of :quantity, :unit_price

  belongs_to :invoice
  belongs_to :item
  has_many :transactions, through: :invoice
end