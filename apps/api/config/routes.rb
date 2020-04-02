get '/healthcheck', to: ->(_) { [200, {}, ['Hello from Lobster!']] }

post '/authenticate', to: 'sessions#authenticate'
get  '/new_token',    to: 'sessions#refresh'

resources :images, only: %i[] do
  collection do
    post :upload
  end
end
