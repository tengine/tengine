# -*- coding: utf-8 -*-

##############################
# deploy stage
##############################
set :stages, %w(development staging production)
set :default_stage, "staging"
require 'capistrano/ext/multistage'

desc "hello task"
task :hello do
  run "echo HelloWorld! $HOSTNAME"
end


### デプロイ手順(初回のみ) ###
# 1. bundle install
# 2. bundle package
# 3. cap production deploy:setup
# 4. cap production deploy:update
# 5. cap production deploy:setup_apache
# 6. cap production deploy:start

### デプロイ手順(2回目移行) ###
# 1. bundle install
# 2. bundle package
# 4. cap production deploy:stop
# 5. cap production deploy:update
# 6. cap production deploy:start


##############################
# settings
##############################
set :application,       "tengine_console"

# default は, tar だが mac 標準の tar は bsdtar で gnutar ではないので zip にする
set :copy_compression,  :zip
set :copy_cache,        false
set :copy_strategy,     :export
set :copy_exclude,      ['.git', '.svn']

set :deploy_via,        :copy
set :deploy_to,         "/var/lib/#{application}"
set :deploy_env,        "production"
set :bundle_dir,        "./vendor/bundle"
set :bundle_without,    [:development, :test, :assets]

# passenger-recipesの設定
set :target_os,    :centos
set :apache_user,  "apache"
set :apache_group, "apache"


##############################
# tasks
##############################
# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

after "deploy:setup",       "app:setup_shared"

before "deploy:update"    , "app:chown_deploy_path"
after "deploy:update_code", "app:symlinks"
after "deploy:update"     , "app:change_owner"

namespace :app do
  desc "setup shared directories"
  task :setup_shared do
    run "#{sudo} chown -R #{user}:#{user} #{deploy_to}"

    run "#{sudo} mkdir -p #{shared_path}/config"
    run "#{sudo} chown -R #{user}:#{user} #{shared_path}"

    put(IO.read("config/event_sender.yml.erb"), "#{shared_path}/config/event_sender.yml.erb", :via => :scp)
    put(IO.read("config/mongoid.yml"), "#{shared_path}/config/mongoid.yml", :via => :scp)
  end

  task :chown_deploy_path do
    run "#{sudo} chown -R #{user}:#{user} #{deploy_to}"
  end

  desc "Make symlink for config_file"
  task :symlinks do
    run "#{sudo} ln -nfs #{shared_path}/config/event_sender.yml.erb #{release_path}/config/event_sender.yml.erb"
    run "#{sudo} ln -nfs #{shared_path}/config/mongoid.yml #{release_path}/config/mongoid.yml"
  end

  task :change_owner do
    run "#{sudo} chown -R #{apache_user}:#{apache_group} #{deploy_to}/"
  end
end


# apache & passenger
namespace :deploy do
  # deploy:startなどを上書き
  task(:start)   { apache.start }
  task(:stop)    { apache.stop }
  task(:restart) { apache.restart }
end

# see /var/log/httpd/error_log
#
# [error] *** Passenger could not be initialized because of this error: Unable to start the Phusion Passenger watchdog (/usr/local/lib/ruby/gems/1.9.1/gems/passenger-3.0.11/agents/PassengerWatchdog): Permission denied (13)
#
# -> setenforce 0

namespace :apache do
  set :apache_bin_path,  "/etc/init.d/httpd"
  set :apache_conf_path, "/etc/httpd/conf.d"

  %w(start stop reload).each do |command|
    desc "apache #{command}"
    task(command, :roles => [:web]) do
      run "#{sudo} #{apache_bin_path} #{command}"
    end
  end

  task :restart, roles => [:web] do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  task :graceful, roles => [:web] do
    run "#{sudo} apachectl graceful", :pty => true
  end

  task :configtest, roles => [:web] do
    run "#{sudo} apachectl configtest"
  end
end


# utility methods
def keep_indent(msg)
  lines = msg.split(/$/)
  indent = lines.first.scan(/^\s*/).first
  lines.map{|line| line.sub(/^#{indent}/, '')}.join
end


# capistrano force stop for 'ctl+c'
Signal.trap(:INT) do
  abort "\n[cap] Inturrupted..."
end
