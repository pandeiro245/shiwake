class FilterLogicsController < ApplicationController
  before_action :authenticate_user!

  def index
    @filterLogics = FilterLogic.where(user_id: current_user.uid)
    render formats: :json
  end

  def create
    @filterLogic = FilterLogic.new(user_id: current_user.uid, keyword: params[:keyword])
    @filterLogic.save
    render json: {}
  end
end
