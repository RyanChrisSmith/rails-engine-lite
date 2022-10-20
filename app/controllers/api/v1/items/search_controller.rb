class Api::V1::Items::SearchController < ApplicationController
  before_action :empty_params,
                :faulty_combo_params,
                :negative_params,
                :empty_or_nil_params


  def index
    if params[:name]
      render json: ItemSerializer.new(Item.search(params[:name]))
    elsif params[:min_price] != nil || params[:max_price] != nil
      render json: ItemSerializer.new(Item.price_search(params))
    end
  end

  def show
    if params[:name]
      render json: ItemSerializer.new(Item.search(params[:name]).first)
    elsif params[:min_price] != nil || params[:max_price] != nil
      render json: ItemSerializer.new(Item.price_search(params).first)
    end
  end


end