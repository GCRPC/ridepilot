set :deploy_to, "/home/deployer/rails/ridepilot"
set :branch, "stable"
set :rvm_ruby_string, '1.9.2'

role :web, "184.154.79.122"
role :app, "184.154.79.122"
role :db,  "184.154.79.122", :primary => true # This is where Rails migrations will run
