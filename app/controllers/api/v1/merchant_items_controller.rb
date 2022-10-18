class Api::V1::MerchantItemsController < ApplicationController
  def index
    if Item.exists?(merchant_id: params[:merchant_id])
      render json: ItemSerializer.new(Item.where(merchant_id: params[:merchant_id]))
    else
      render json: { errors: { details: "No items were found for a merchant with id: #{params[:merchant_id]}" }}, status: 404
    end
  end
end