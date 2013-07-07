require 'google/api_client'

class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_oauth_info

  def set_oauth_info
    client.authorization.client_id     = ENV['CLIENT_ID'] || oauth_yaml['client_id']
    client.authorization.client_secret = ENV['CLIENT_SECRET'] || oauth_yaml['client_secret']
    client.authorization.scope         = ENV['SCOPE'] || oauth_yaml['scope']
    client.authorization.redirect_uri  = oauth2callback_url
    client.authorization.access_token  = ENV['ACCESS_TOKEN'] || oauth_yaml['access_token']
    client.authorization.code          = params[:code] if params[:code]

    if session[:token_id]
      token_pair = TokenPair.find(session[:token_id])
      client.authorization.update_token!(token_pair.to_hash)
    end

    if client.authorization.refresh_token && client.authorization.expired?
      client.authorization.fetch_access_token!
    end

    unless client.authorization.access_token || request.path_info =~ /^\/oauth2/
      redirect_to oauth2authorize_url
    end
  end

  def client
    @client ||= Google::APIClient.new
  end

  def oauth_yaml
    YAML.load_file("#{Rails.root.to_s}/config/google_api.yml")
  end
end
