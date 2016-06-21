class AnalyticsController < ApplicationController

  before_action :logged_in_user

  def index

  end

  def announcement_analytics
    last_days = params[:last_days] || 7
    @announcements = Announcement.last_days(last_days)
    @deals_hash = Deal.last_days(last_days).status_success.group(:price).count
    @deals = Deal.last_days(last_days).status_success
    @last_days = params[:last_days]
    respond_to do |format|
      format.html
      format.json {render json: @deals_hash}
    end
  end

end
