require 'trello'
class TrelloMine
  def self.id2labels id
    Trello.configure do |config|
      config.consumer_key = Settings.trello.client_id
      config.consumer_secret = Settings.trello.client_secret
      config.oauth_token = Settings.trello.token
    end
    res = []
    Trello::Card.find(id).attributes[:card_labels].map do |t|
      id = t['name'].match(/[0-9]*$/).to_s.to_i
      res.push(id) if id > 0
    end
  end
end
