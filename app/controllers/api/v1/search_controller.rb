class Api::V1::SearchController < ApplicationController

  def find_all_merchants
    if params[:name] == ""
      render status: 400
    else
      merchant = Merchant.where("name ILIKE ?", "%#{params[:name]}%")
      render json: MerchantSerializer.new(merchant)
    end
  end
end