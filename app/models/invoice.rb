class Invoice < ApplicationRecord
  validates_presence_of :status

  belongs_to :customer
  belongs_to :merchant
  has_many :invoice_items
  has_many :transactions, dependent: :destroy
  has_many :items, through: :invoice_items
  # has_many :merchants, through: :items
end