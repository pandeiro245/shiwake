class FilterLogicsController < ApplicationController
  before_action :authenticate_user!

  def create
    @filterLogic = FilterLogic.new(user_id: current_user.uid, keyword: params[:keyword])
    @filterLogic.save
    render json: {}
  end
end
