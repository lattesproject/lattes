set :stage, :production
server '34.229.211.28', user: 'deploy', roles: %w{web app db}
