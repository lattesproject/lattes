set :stage, :production
server '54.175.93.8', user: 'deploy', roles: %w{web app db}
