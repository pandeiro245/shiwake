class FilterLogicsController < ApplicationController
  before_action :authenticate_user!

  def index
    @filterLogics = FilterLogic.where(user_id: current_user.uid)
    render formats: :json
  end

  def download
    @filterLogics = FilterLogic.where(user_id: current_user.uid)
    send_data render_to_string(formats: :json), filename: "filterLogic_#{Time.zone.now.strftime('%Y%m%d')}.json", type: :json
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
