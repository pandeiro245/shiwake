class FilterLogicsController < ApplicationController
  before_action :authenticate_user!

  def index
    @filterLogics = FilterLogic.where(user_id: current_user.uid)
    render formats: :json
  end

  def create
    @filterLogic = FilterLogic.new(user_id: current_user.uid, keyword: params[:keyword])
    if @filterLogic.save
      render json: { }
    else
      render json: { errors: @filterLogic.errors.full_messages }
    end
  end
end
