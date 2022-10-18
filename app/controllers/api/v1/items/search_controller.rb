class Api::V1::Items::SearchController < ApplicationController
  def find_one
    if params[:name].present? && params[:min_price].present? || params[:max_price].present? && params[:name].present?
      render json: {errors: { details: "Must search by name OR price"}}, status: 400
    elsif params[:min_price] != nil || params[:max_price] != nil
      render json: ItemSerializer.new(Item.price_search(params))
    elsif params[:name].present?
      render json: ItemSerializer.new(Item.search(params[:name]))
    end
  end
end