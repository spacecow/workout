require "delayed/recipes"
#require "bundler/capistrano"

# whenever
set :whenever_command, "bundle exec whenever"
require "whenever/capistrano"

#delayed job
set :rails_env, "production"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :repository, "git@github.com:spacecow/workout.git"
set :scm, "git"
set :branch, "master"
set :deploy_via, :remote_cache
set :use_sudo, false

set :application, "workout"
set :deploy_to, "/home/ghazal/apps/#{application}"
set :user, "ghazal"
set :admin_runner, "ghazal"
  
role :app, "106.187.50.182"
role :web, "106.187.50.182"
role :db,  "106.187.50.182", :primary => true

set :default_environment, { 'PATH' => "/home/ghazal/.rvm/gems/ruby-1.9.2-head/bin:$PATH" }

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  task :symlink_shared do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
end

# create new whenever command for clear crontab
#namespace :whenever do
#  desc <<-DESC
#    Modified from the original to change to current_path instead of release_path
#  DESC
#  task :clear_current_crontab do
#    options = { :roles => whenever_roles }
#    run "cd #{fetch :current_path} && #{fetch :whenever_command}  --clear-crontab #{fetch :whenever_identifier}", options if find_servers(options).any?
#  end
#end

after 'deploy:update_code', 'deploy:symlink_shared'
#after 'deploy:restart', 'delayed_job:restart'
