class Api::V1::ItemsMerchantController < ApplicationController
  def index
    if item = Item.find(params[:item_id])
      render json: MerchantSerializer.new(Merchant.find(item.merchant_id))
    else
      render status: 404
    end
  end
end