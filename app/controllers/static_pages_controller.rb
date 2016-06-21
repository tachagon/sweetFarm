class StaticPagesController < ApplicationController

	def index
    if logged_in?
      @per_page = params[:per_page] ? params[:per_page] : 12
      @role = params[:role]
      @announcements = Announcement.show.not_expired.recent.paginate(page: params[:page], per_page: @per_page)

      if params[:province] && params[:province] != ""
        @province = Province.find(params[:province])
        @announcements = @province.announcements.show.not_expired.recent.paginate(page: params[:page], per_page: @per_page)
      end

      if params[:amphur] && params[:amphur] != ""
        @amphur = Amphur.find(params[:amphur])
        @announcements = @amphur.announcements.show.not_expired.recent.paginate(page: params[:page], per_page: @per_page)
      end

      if params[:district] && params[:district] != ""
        @district = District.find(params[:district])
        @announcements = @district.announcements.show.not_expired.recent.paginate(page: params[:page], per_page: @per_page)
      end

      @announcements = @announcements.role(params[:role]) if params[:role] && params[:role] != ""
      respond_to do |format|
        format.html
        format.json{render json: @announcements}
        format.xml{render xml: @announcements}
      end
    end

	end

	def page2

	end

  def settings

  end

end
