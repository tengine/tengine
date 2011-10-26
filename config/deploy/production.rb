# -*- coding: utf-8 -*-
require 'bundler/capistrano'


##############################
# setting server and roles
##############################
role :web, "tgnweb001", "tgnweb002"
role :app, "tgnweb001", "tgnweb002"
role :db,  "tgnweb001", :primary => true # This is where Rails migrations will run
role :db,  "tgnweb002"

set :application,       "tengine_console"
set :user,              "root"
set :password,          "password"
set :use_sudo,          false
set :ssh_options, {
  :forward_agent => true
}


##############################
# setting scm
##############################
set :scm_verbose,       true
set :scm_user,          "root"
set :scm_prefer_prompt, true    # 毎回パスワードを入力する設定

set :scm,               :none
set :repository,        "."

set :copy_compression,  :zip
set :deploy_via,        :copy
set :deploy_to,         "/var/lib/#{application}"
set :bundle_dir,        "./vendor/bundle"
set :keep_releases,     3

##############################
# tasks
##############################
# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

### デプロイ手順 ###
# 1. cap ROLE=app deploy:setup
# 2. cap ROLE=app deploy:update
# 3. cap deploy:start

after "deploy:setup",       "app:setup_shared"
after "deploy:update_code", "app:symlinks"

namespace :app do
  desc "setup shared directories"
  task :setup_shared do
    run "mkdir -p #{shared_path}/config"

    config_mongoid = "#{shared_path}/config/mongoid.yml"
    put(IO.read("config/mongoid.yml.example"), config_mongoid, :via => :scp)
  end

  desc "Make symlink for shared/config/tengined.yml"
  task :symlinks do
    run "ln -nfs #{shared_path}/config/mongoid.yml #{release_path}/config/mongoid.yml"
  end
end

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

