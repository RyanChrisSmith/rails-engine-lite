class Api::V1::SearchController < ApplicationController

  def find_all_merchants
    if params[:name] == ""
      render status: 400
    else
      merchant = Merchant.where('name ILIKE ?', "%#{params[:name]}%")
      render json: MerchantSerializer.new(merchant)
    end
  end

  def find_item
    item = Item.where('name ILIKE ?', "%#{params[:name]}%").or(Item.where('description ILIKE ?', "%#{params[:name]}%")).first
    if item.nil?
      render json: { data: {message: 'No matching item'}}, status: 400
    else
      render json: ItemSerializer.new(item)
    end
  end

end