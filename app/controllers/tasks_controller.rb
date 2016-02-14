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

  def show
    id = params[:id]
    team_id = params[:team_id]
    @task = client.team_task(team_id, id)

    @parent_task = client.team_task(team_id, @task['parent_id'])
    @expected_parent_tasks = []
    if @task['url'].match(/trello.com\/c\//)
      trello_id = @task['url'].gsub(/https:\/\/trello.com\/c\//,'').split('/').first
      TrelloMine.id2labels(trello_id).each do |task_id|
        t = client.team_task(team_id, task_id)
        @expected_parent_tasks.push(t) if t.present?
      end
    end

    if params[:update] #FIXME
      parent_id = @expected_parent_tasks.first['id']
      client.update_team_task(params[:team_id], params[:id], { parent_id: parent_id })
    end

    @children = client.team_tasks(team_id, 'all', 1, id)
  end

  def update
    client.update_team_task(params[:team_id], params[:id], { parent_id: params[:parent_id] })
    render json: {}
  end
end
