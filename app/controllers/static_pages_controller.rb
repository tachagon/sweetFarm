class StaticPagesController < ApplicationController

	def index
    @per_page = params[:per_page] ? params[:per_page] : 12
    @announcements = Announcement.show.not_expired.recent.paginate(page: params[:page], per_page: @per_page)
    respond_to do |format|
      format.html
      format.json{render json: @announcements}
      format.xml{render xml: @announcements}
    end
	end

	def page2

	end

  def settings

  end

end
