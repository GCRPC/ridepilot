ps aux | grep 'unicorn-lite' | awk '{print $2}' | xargs sudo kill -9  
bundle exec unicorn_rails -c ~/ridepilot/shared/config/unicorn-lite.conf.rb -D -E production    
sudo service nginx restart