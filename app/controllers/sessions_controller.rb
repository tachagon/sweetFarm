class SessionsController < ApplicationController

  def new

  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      flash[:success] = 'เข้าสู่ระบบสำเร็จแล้ว'
      redirect_back_or root_path
    else
      flash.now[:danger] = t('views.sessions.new.error')
      render 'new'
    end
  end

  # create session from single sign on and log in
  def create_with_single_sign_on
    auth = request.env["omniauth.auth"]
    sso_user = SingleSignOn.find_by_provider_and_uid(auth["provider"], auth["uid"]) || SingleSignOn.create_with_omniauth(auth)
    user = User.find_by_id(sso_user.user)
    # new user
    unless user
      user = User.find_by_email(auth["info"]["email"])

      # User don't have email in database
      user = User.create_with_omniauth(auth) unless user

      log_in user
      sso_user.user = user
      sso_user.save
      redirect_to edit_user_path(id: user, locale: I18n.locale) and return
    end
    flash[:success] = 'เข้าสู่ระบบสำเร็จแล้ว'
    log_in user
    redirect_back_or root_path
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

end
