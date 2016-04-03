class ProvincesController < ApplicationController

  def index
    @provinces = Province.order(:PROVINCE_NAME)
    respond_to do |format|
      format.html
      format.json{render json: @provinces}
    end
  end

end
