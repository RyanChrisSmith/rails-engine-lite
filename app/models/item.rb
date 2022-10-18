class Item < ApplicationRecord
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  belongs_to :merchant

  validates_presence_of :name, :description, :unit_price

  def self.search(name)
    where('name ILIKE ?', "%#{name}%").or(Item.where('description ILIKE ?', "%#{name}%")).first
  end

  def self.price_search(prices)
    if prices.include?(:min_price) && !prices.include?(:max_price)
      where("unit_price >= ?", prices[:min_price].to_f)
    elsif prices.include?(:max_price) && !prices.include?(:min_price)
      where("unit_price <= ?", prices[:max_price].to_f)
    elsif prices.include?(:min_price) && prices.include?(:max_price)
      where("unit_price BETWEEN ? AND ?", prices[:min_price].to_f, prices[:max_price].to_f)
    end
  end
end
