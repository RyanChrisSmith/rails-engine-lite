class Api::V1::Merchants::SearchController < ApplicationController
  def find_all
    if params[:name] == "" || !params.include?(:name)
      render json: { errors: {details: "A name must be provided to search" }}, status: 400
    elsif Merchant.search_all(params[:name]) == []
      render json: { data: [] }, status: 404
    else
      render json: MerchantSerializer.new(Merchant.search_all(params[:name]))
    end
  end
end