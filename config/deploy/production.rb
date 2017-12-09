set :stage, :production
server '54.173.78.105', user: 'deploy', roles: %w{web app db}
