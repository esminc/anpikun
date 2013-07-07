class AuthController < ApplicationController
  def oauth2authorize
    redirect_to @client.authorization.authorization_uri.to_s
  end

  def oauth2callback
    @client.authorization.fetch_access_token!

    token_pair = find_or_create_token_pair
    token_pair.update_token!(@client.authorization)
    session[:token_id] = token_pair.id

    redirect_to '/'
  end

  def result
    result   = @client.execute(uri: 'https://www.googleapis.com/oauth2/v1/userinfo')
    response = result.response.to_s

    render json: {token_id: session[:token_id], response: response}
  end

  private

  def find_or_create_token_pair
    if session[:token_id]
      TokenPair.find(session[:token_id])
    else
      TokenPair.create
    end
  end
end
