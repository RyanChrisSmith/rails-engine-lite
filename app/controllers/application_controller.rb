class ApplicationController < ActionController::API
private
  def empty_params
    if (params[:name]) == "" || params[:min_price] == "" || params[:max_price] == ""
      render json: {errors: { details: "A value must be input for searching"}}, status: 400
    end
  end

  def faulty_combo_params
    if params[:name].present? && params[:min_price].present? || params[:max_price].present? && params[:name].present?
      render json: {errors: { details: "Must search by name OR price"}}, status: 400
    end
  end

  def negative_params
    if (params[:min_price]).to_i < 0 || (params[:max_price]).to_i < 0
      render json: {errors: { details: "Price search cannot use a negative number"}}, status: 400
    end
  end

  def empty_or_nil_params
    if Item.search(params[:name]).nil? || Item.price_search(params) == [] || Item.search(params[:name]) == []
      render json: {data: {}}
    end
  end

  def check_params
    if params[:name] == "" || !params.include?(:name)
      render json: { errors: {details: "A name must be provided to search" }}, status: 400
    end
  end

end
