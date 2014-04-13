source 'https://rubygems.org'

gem 'rails', '3.2.17'
gem 'jquery-rails'
gem 'jquery-ui-rails'
#gem "watu_table_builder", :require => "table_builder"
gem 'cancan'
gem 'simple_form'
gem 'delayed_job_active_record'
gem 'daemons'
gem 'delayed_job_web'
gem 'whenever', require:false
gem 'carrierwave'
gem 'rmagick', '2.13.2'
gem 'pry'
gem 'heroku'
# gem 'rb-inotify', '~> 0.8.8'
gem 'will_paginate'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'bcrypt-ruby'
  gem 'compass-rails'
  gem "fancy-buttons", :git => 'https://github.com/imathis/fancy-buttons.git'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', '0.12.1', :platforms => :ruby
end

group :test, :development do
  gem 'rspec-rails', "~> 2.0"
  gem 'mysql2'
end

group :development do
  gem 'guard-spork'
end

group :test do
  gem 'spork-rails' #, '> 0.9.0.rc'
  gem 'guard'
  gem 'guard-rspec'
  gem 'factory_girl_rails' #, '1.2.0'
  gem 'launchy'
  gem 'capybara'
  gem 'its'
end

group :production do
  gem 'pg', '0.15.1'
  gem 'rails_12factor', '0.0.2'
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
