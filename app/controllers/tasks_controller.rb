class TasksController < ApplicationController
  before_action :authenticate_user!

  def index
    limit = 300

    team_id = params[:team_id]
    key = "tasks/#{team_id}"
    Rails.cache.delete(key) if params[:refresh]
    @tasks = Rails.cache.fetch(key) do
      page = 1
      data = client.team_tasks(team_id, 'all', page)
      tasks = data
      while data.present? && page < limit
        page += 1
        data = client.team_tasks(team_id, 'all', page)
        tasks += data
      end
      tasks.sort { |a, b| a['path'] <=> b['path'] }
    end
    render formats: :json
  end

  def update
    client.update_team_task(params[:team_id], params[:id], { parent_id: params[:parent_id] })
    render json: {}
  end
end
