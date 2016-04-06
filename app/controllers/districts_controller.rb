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

  def show
    if params[:id]
      @district = District.find(params[:id])

      respond_to do |format|
        format.html
        format.json{render json: @district}
        format.xml{render xml: @district}
      end
    else
      redirect_to root_path
    end

  end

  def show_amphur
    if params[:id]
      @district = District.find(params[:id])
      @amphur = @district.amphur

      respond_to do |format|
        format.html
        format.json{render json: @amphur}
        format.xml{render xml: @amphur}
      end
    else
      redirect_to root_path
    end
  end

  def show_province
    if params[:id]
      @district = District.find(params[:id])
      @province = @district.province

      respond_to do |format|
        format.html
        format.json{render json: @province}
        format.xml{render xml: @province}
      end
    else
      redirect_to root_path
    end
  end

end
