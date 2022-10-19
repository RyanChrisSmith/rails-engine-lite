class Api::V1::Items::SearchController < ApplicationController
  before_action :check_for_faulty_params

  def find_one
    if params[:name]
      render json: ItemSerializer.new(Item.search(params[:name]))
    elsif params[:min_price] != nil || params[:max_price] != nil
      render json: ItemSerializer.new(Item.price_search(params).first)
    end
  end


  private
  def check_for_faulty_params
    if (params[:name]) == "" || params[:min_price] == "" || params[:max_price] == ""
      render status: 400
    elsif params[:name].present? && params[:min_price].present? || params[:max_price].present? && params[:name].present?
      render json: {errors: { details: "Must search by name OR price"}}, status: 400
    elsif (params[:min_price]).to_i < 0 || (params[:max_price]).to_i < 0
      render json: {errors: { details: "Price search cannot use a negative number"}}, status: 400
    elsif Item.search(params[:name]).nil? || Item.price_search(params) == []
      render json: {data: {}}
    end
  end
end