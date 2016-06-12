class AmphursController < ApplicationController

  def index
    @province = Province.find(params[:province_id])
    @amphurs = Amphur.where(PROVINCE_ID: @province.id)

    respond_to do |format|
      format.html
      format.json{render json: @amphurs}
    end
  end

end
