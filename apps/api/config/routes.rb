get '/healthcheck', to: ->(_) { [200, {}, ['Hello from Lobster!']] }
