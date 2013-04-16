require "delayed/recipes"
#require "bundler/capistrano"

# whenever
set :whenever_command, "bundle exec whenever"
require "whenever/capistrano"

# get capistrano to see rvm path
# ------------------------------
# Add RVM's lib directory to the load path.
# $:.unshift(File.expand_path('./lib', ENV['rvm_path']))

# Load RVM's capistrano plugin.    
# require "rvm/capistrano"

# set :rvm_ruby_string, '1.9.2-head'
# set :rvm_type, :user  # Don't use system-wide RVM
# ------------------------------


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
set :deploy_to, "/home/aurora/apps/#{application}"
set :user, "aurora"
set :admin_runner, "aurora"
  
role :app, "sao.fir-vpc.riec.tohoku.ac.jp"
role :web, "sao.fir-vpc.riec.tohoku.ac.jp"
role :db,  "sao.fir-vpc.riec.tohoku.ac.jp", :primary => true

#set :rake, "~/.rvm/rubies/ruby-1.9.2-head/bin/rake"
#set :default_environment, { 
#  'PATH' => "/home/aurora/.rvm/rubies/ruby-1.9.2-head/bin:/home/aurora/.rvm/gems/ruby-1.9.2-head/bin:/home/aurora/.rvm/bin:$PATH",
#  'RUBY_VERSION' => 'ruby 1.9.2',
#  'GEM_HOME' => '/home/aurora/.rvm/gems/ruby-1.9.2-head',
#  'GEM_PATH' => '/home/aurora/.rvm/gems/ruby-1.9.2-head' 
#}


namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  task :symlink_shared do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/uploads #{release_path}/public/uploads"    
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
