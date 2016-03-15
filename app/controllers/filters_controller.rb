class FiltersController < ApplicationController
  def index
    render json: Filter.where(team_id: params[:team_id])
  end
end
