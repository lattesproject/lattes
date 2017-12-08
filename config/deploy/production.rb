set :stage, :production
server '54.242.198.115', user: 'deploy', roles: %w{web app db}
