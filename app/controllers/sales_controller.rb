class SalesController < ApplicationController

  before_action :logged_in_user
  before_action :correct_user, only: [:new, :create, :edit, :update]
  before_action :admin_user, only: [:destroy]

  def index
    @user = User.find_by_id(params[:user_id])
    @sales = @user.sales
  end

  def show
    @sale = Sale.find_by_id(params[:id])
  end

  def new
    @sale = current_user.sales.build
  end

  def create
    @sale = current_user.sales.build(sale_params)
    if @sale.save
      flash[:success] = 'ประกาศขายอ้อยสำเร็จ'
      redirect_to user_sales_path(current_user)
    else
      render 'new'
    end
  end

  def edit
    @sale = current_user.sales.find_by_id(params[:id])
  end

  def update
    @sale = current_user.sales.find_by_id(params[:id])
    unless @sale.nil?
      if @sale.update_attributes(sale_params)
        flash[:success] = 'แก้ไขข้อมูลสำเร็จแล้ว'
        redirect_to user_sale_path(user_id: current_user, id: @sale)
      else
        render 'edit'
      end
    else
      flash[:danger] = 'คุณไม่สามารถแก้ไขประกาศนี้ได้'
      redirect_to user_sales_path(user_id: current_user)
    end

  end

  def destroy
    Sale.find_by_id(params[:id]).destroy
    flash[:success] = 'Deleted successful'
    redirect_to admin_all_sales_path
  end

  private
    # def current_user_only
    #   @user = User.find_by_id(params[:user_id])
    #   unless @user == current_user
    #     unless current_user.admin?
    #       redirect_to root_path, :alert => "Access denied."
    #     end
    #   end
    # end

    # Confirms the correct user.
    def correct_user
      @user = User.find_by_id(params[:user_id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # def admin_only
    #   unless current_user.admin?
    #     redirect_to :back, :alert => "Access denied."
    #   end
    # end

    def sale_params
      params.require(:sale).permit(:amount, :price, :district_id)
    end

end
