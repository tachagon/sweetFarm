class MessagesController < ApplicationController

  before_action :get_deal, only: [:index, :create]

  def index
    @messages = @deal.messages
    respond_to do |format|
      format.html
      format.json{render json: @messages}
      format.xml{render xml: @messages}
    end
  end

  def create
    @user = User.find_by_id(params[:user_id])
    @message = Message.new(
      user: @user,
      deal: @deal,
      body: params[:body]
    )

    respond_to do |format|
      if @message.save
        format.html {redirect_to deal_path(@deal)}
        format.js
        format.json{render json: @message}
      else
        format.html {redirect_to deal_path(@deal)}
      end
    end

  end

  private

    def get_deal
      @deal = Deal.find_by_id(params[:deal_id])
    end

end
