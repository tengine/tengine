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
after "deploy:update_code", "app:symlinks"
after "deploy:update_code", "app:change_owner"

namespace :app do
  desc "setup shared directories"
  task :setup_shared do
    run "mkdir -p #{shared_path}/config"
    put(IO.read("config/tengined.yml.erb"), "#{shared_path}/config/tengined.yml.erb", :via => :scp)
    put(IO.read("config/event_sender.yml.erb"), "#{shared_path}/config/event_sender.yml.erb", :via => :scp)
    put(IO.read("config/mongoid.yml"), "#{shared_path}/config/mongoid.yml", :via => :scp)
  end

  desc "Make symlink for config_file"
  task :symlinks do
    run "ln -nfs #{shared_path}/config/tengined.yml #{release_path}/config/tengined.yml"
    run "ln -nfs #{shared_path}/config/event_sender.yml #{release_path}/config/event_sender.yml"
    run "ln -nfs #{shared_path}/config/mongoid.yml #{release_path}/config/mongoid.yml"
  end

  task :change_owner do
    run "chown -R #{apache_user}:#{apache_group} #{deploy_to}/"
  end
end


# apache & passenger
namespace :deploy do
  # deploy:startなどを上書き
  task(:start)   { apache.start }
  task(:stop)    { apache.stop }
  task(:restart) { apache.restart }
  task(:setup_apache) {
    apache.passenger.load_module
    apache.passenger.make_config
  }
end


namespace :apache do
  set :apache_bin_path,  "/etc/init.d/httpd"
  set :apache_conf_path, "/etc/httpd/conf.d"

  %w(start stop reload).each do |command|
    desc "apache #{command}"
    task(command, :roles => [:web]) do
      run "#{apache_bin_path} #{command}"
      run "ps -ef | grep httpd | grep -v grep"
    end
  end

  task :restart, roles => [:web] do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
    run "ps -ef | grep httpd | grep -v grep"
  end

  task :graceful, roles => [:web] do
    run "apachectl graceful", :pty => true
  end

  task :configtest, roles => [:web] do
    run "apachectl configtest"
  end

  namespace :passenger do
    desc "make load module configrate"
    task :load_module do
      path = "#{apache_conf_path}/passenger.conf"
      put(keep_indent(<<-EOS), path, :via => :scp)
      LoadModule passenger_module /usr/local/lib/ruby/gems/1.9.1/gems/passenger-3.0.9/ext/apache2/mod_passenger.so
      PassengerRoot /usr/local/lib/ruby/gems/1.9.1/gems/passenger-3.0.9
      PassengerRuby /usr/local/bin/ruby
      EOS
    end

    desc "make web configuration"
    task :make_config do
      server_name = capture("hostname")
      path = "#{apache_conf_path}/#{application}.conf"
      put(keep_indent(<<-EOS), path, :via => :scp)
      <VirtualHost *:80>
          ServerName #{server_name}
          DocumentRoot #{current_path}/public
          <Directory #{current_path}/public>
              Allow from all
              Options -MultiViews
              RailsBaseURI /
          </Directory>
      </VirtualHost>
      EOS
    end
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
