Anpikun::Application.routes.draw do
  root to: 'haneda#show'

  match 'oauth2authorize' => 'auth#oauth2authorize'
  match 'oauth2callback'  => 'auth#oauth2callback'
  get 'auth/result'
end
