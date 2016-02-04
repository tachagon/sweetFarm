class ApplicationController < ActionController::Base
	before_action :set_locale
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  private

    def set_locale
    	I18n.locale = params[:locale] || I18n.default_locale
    end

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = t('controllers.applications.logged_in_user.caution')
        redirect_to login_path
      end
    end

end
