set :stage, :production
server '184.72.197.89', user: 'deploy', roles: %w{web app db}
