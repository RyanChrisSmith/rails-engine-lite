class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  has_many :invoice_items, through: :items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  def self.search_all(name)
    where('name ILIKE ?', "%#{name}%").order('name')
  end
end
