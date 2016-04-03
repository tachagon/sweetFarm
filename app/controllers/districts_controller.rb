class DistrictsController < ApplicationController

  def index
    @province = Province.find(params[:province_id])
    @amphur = Amphur.find(params[:amphur_id])
    @districts = District.where(PROVINCE_ID: @province.id, AMPHUR_ID: @amphur.id)

    respond_to do |format|
      format.html
      format.json{render json: @districts}
    end
  end

end
