class Api::V1::Merchants::SearchController < ApplicationController
  before_action :check_params

  def index
    if Merchant.search_all(params[:name]) == []
      render json: { data: [] }, status: 404
    else
      render json: MerchantSerializer.new(Merchant.search_all(params[:name]))
    end
  end

  def show
    if Merchant.search_all(params[:name]) == []
      render json: { data: {} }, status: 404
    else
      render json: MerchantSerializer.new(Merchant.search_all(params[:name]).first)
    end
  end
end