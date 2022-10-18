class Api::V1::ItemsMerchantController < ApplicationController
  def index
    if Item.exists?(params[:item_id])
      item = Item.find(params[:item_id])
      render json: MerchantSerializer.new(Merchant.find(item.merchant_id))
    else
      render json: { errors: { details: "No items were found with item id: #{params[:item_id]}" }}, status: 404
    end
  end
end