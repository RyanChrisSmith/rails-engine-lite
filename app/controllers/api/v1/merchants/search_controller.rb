class Api::V1::Merchants::SearchController < ApplicationController
  def index
    if params[:name] == ""
      render status: 400
    else
      merchant = Merchant.where('name ILIKE ?', "%#{params[:name]}%")
      render json: MerchantSerializer.new(merchant)
    end
  end
end