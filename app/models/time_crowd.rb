class TimeCrowd
  attr_accessor :client, :access_token

  def initialize(credentials)
    self.client = OAuth2::Client.new(
      Settings.timecrowd.client_id,
      Settings.timecrowd.client_secret,
      site: Settings.timecrowd.site,
      ssl: { verify: false }
    )
    self.access_token = OAuth2::AccessToken.new(
      client,
      credentials.token,
      refresh_token: credentials.refresh_token,
      expires_at: credentials.expires_at
    )
    self.access_token = access_token.refresh! if self.access_token.expired?
    access_token
  end

  def teams(state = nil)
    access_token.get("/api/v1/teams?state=#{state}").parsed
  end

  def team(id)
    access_token.get("/api/v1/teams/#{id}").parsed
  end

  def team_tasks(team_id, state = nil, page=1, parent_id=nil)
    url = "/api/v1/teams/#{team_id}/tasks?state=#{state}"
    url += "&page=#{page}" if page
    url += "&parent_id=#{parent_id}" if parent_id
    access_token.get(url).parsed
  end

  def team_task(team_id, id)
    access_token.get("/api/v1/teams/#{team_id}/tasks/#{id}").parsed
  end

  def update_team_task(team_id, id, task)
    access_token.put(
      "/api/v1/teams/#{team_id}/tasks/#{id}", 
      body: {task: task}
    ).parsed
  end
end

