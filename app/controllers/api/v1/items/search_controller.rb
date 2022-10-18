class Api::V1::Items::SearchController < ApplicationController
  def show
    if params[:name]
      item = Item.where('name ILIKE ?', "%#{params[:name]}%").or(Item.where('description ILIKE ?', "%#{params[:name]}%")).first
    elsif params[:min_price]
      item = Item.where("items.unit_price >=?", params[:min_price]).order(:name)
    end

    if item.nil?
      render json: { data: {message: 'No matching item'}}, status: 400
    else
      render json: ItemSerializer.new(item)
    end
  end
end