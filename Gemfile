# -*- coding: utf-8 -*-
# mac-mini or rubycenter server in gemserver
source "http://dev.tenginefw.com/gemserver"
source 'http://rubygems.org'

# すぐにパッチが出る事を予想しています。リリース近くなったらバージョンを固定します。
gem 'rails', '~> 3.1.0'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem "selectable_attr", "~> 0.3.14"
gem "selectable_attr_rails", "~> 0.3.14"

gem "mongoid", "~> 2.2.0"
gem "bson_ext", "~> 1.3.1"

gem "kaminari", "~> 0.12.4"

gem "tengine_event", "~> 0.2.4"
gem "tengine_core", "~> 0.0.15"

gem "daemons", "~> 1.1.4"

group :test, :development do
  gem "rspec-rails", "~> 2.6.1"
  gem "capybara", "~> 1.1.1"
  gem "factory_girl_rails", "~> 1.2.0"
  gem "rails3-generators", "~> 0.17.4"

  gem "cucumber-rails", "~> 1.0.5"
  gem "database_cleaner", "~> 0.6.7"

  gem "pickle", "~> 0.4.10"
  gem 'pickle_i18n', '~> 0.0.4'

  gem "ZenTest", "~> 4.5.0"
  gem "autotest-rails", "~> 4.1.1"

  # gem "rcov", ">= 0"
  gem "simplecov", "~> 0.5.3"
end


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "  ~> 3.1.0"
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier', "~> 1.0.3"
end

gem 'jquery-rails', "~> 1.0.14"

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

gem 'capistrano'       , "~> 2.8.0"
gem 'capistrano-ext'   , "~> 1.2.1"
gem 'capistrano_colors', "~> 0.5.5"





###### for tengine_resource

# http://rightaws.rubyforge.org/
# http://github.com/rightscale/right_aws
gem "right_aws", "~> 2.1.0"
