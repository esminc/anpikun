require 'google/api_client'
require 'yaml'

module CalendarClient
  extend self

  def get_body(email, time_min = Time.now.beginning_of_day.iso8601, time_max = Time.now.end_of_day.iso8601)
    set_authorize_info

    if client.authorization.refresh_token && client.authorization.expired?
      client.authorization.fetch_access_token!
    end

    execute(email, time_min, time_max)
  end

  private

  def client
    @client ||= Google::APIClient.new
  end

  def oauth_yaml
    YAML.load_file("#{Rails.root.to_s}/config/google_api.yml")
  end

  def set_authorize_info
    client.authorization.client_id     = oauth_yaml['client_id']
    client.authorization.client_secret = oauth_yaml['client_secret']
    client.authorization.scope         = oauth_yaml['scope']
    client.authorization.refresh_token = oauth_yaml['refresh_token']
    client.authorization.access_token  = oauth_yaml['access_token']
  end

  def service
    client.discovered_api('calendar', 'v3')
  end

  def execute(email, time_min, time_max)
    client.execute(api_method: service.events.list, parameters: {'calendarId' => "#{email}", 'timeMin' => time_min, 'timeMax' => time_max})
  end
end
