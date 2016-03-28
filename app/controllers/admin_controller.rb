class AdminController < ApplicationController

  before_action :logged_in_user
  before_action :admin_user

  def menu

  end

  def all_sales
    @sales = Sale.all
  end

end
