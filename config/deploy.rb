# -*- coding: utf-8 -*-
set :application, "tengine"

#####################
# deploy stage
#####################
set :stages, %w(development staging production)
set :default_stage, "production"
require 'capistrano/ext/multistage'


#####################
# setting roles
#####################
# role :web, "your web-server here"                          # Your HTTP server, Apache/etc
# role :app, "your app-server here"                          # This may be the same as your `Web` server
# role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
# role :db,  "your slave db-server here"
# server 単位で role の設定が書けるようになってました
server "192.168.1.54", :web, :app, :mq, :db

set :use_sudo,    false
set :user,        'root'
set :password,    'password'
set :ssh_options, {
  :forward_agent => true
}


#####################
# setting scm
#####################
set :scm, :git
set :scm_verbose, true
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`, and `file://`

set :repository,  'ssh://git@cloud-dev.ec-one.com/tengine_console.git'  # rubyセンターへ変更予定
set :branch,      'develop'

set :deploy_to,   "$HOME/#{application}"
# set :deploy_via,  :remote_cache
set :deploy_via,  :copy   # ローカル環境でSCMリポジトリからソースを取得して、サーバへ固めてコピーしてdeployする
set :copy_cache,  true
set :keep_releases, 3

set :bundle_roles, :app


#####################
# tasks
#####################
# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

desc "hello task"
task :hello, :roles => [:app, :web, :db] do
  run "echo HelloWorld! $HOSTNAME"
end

namespace :app do
  desc "setup shared directories"
  task :setup_shared do
    # run "mkdir -p #{shared_path}/vendor/bundle"

    run "mkdir -p #{shared_path}/tmp/tengined_pids"
    run "mkdir -p #{shared_path}/tmp/tengined_status"
    run "mkdir -p #{shared_path}/tmp/tengined_activations"

    run "mkdir -p #{shared_path}/config"

    config_mongoid = "#{shared_path}/config/mongoid.yml"
    put(IO.read("config/mongoid.yml.example"), config_mongoid, :via => :scp)
    config_tengined = "#{shared_path}/config/tengined.yml"
    put(IO.read("config/tengined.yml.example"), config_tengined, :via => :scp)
  end

  desc "Make symlink for shared/config/tengined.yml"
  task :symlinks do
    # run "ln -fs #{shared_path}/vendor/bundle #{release_path}/vendor/bundle"

    run "ln -fs #{shared_path}/tmp/tengined_pids #{release_path}/tmp/tengined_pids"
    run "ln -fs #{shared_path}/tmp/tengined_status #{release_path}/tmp/tengined_status"
    run "ln -fs #{shared_path}/tmp/tengined_activations #{release_path}/tmp/tengined_activations"

    run "ln -nfs #{shared_path}/config/mongoid.yml #{release_path}/config/mongoid.yml"
    run "ln -nfs #{shared_path}/config/tengiened.yml #{release_path}/config/tengined.yml"
  end
end

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
namespace :deploy do
  task :deploy, :roles => :app do
    # tengineコアサーバでイベントハンドラ定義の
    run "cap deploy:~"
  end

  task :start, :roles => :app do
    run "tengined -D -T ./spec_dsl"
  end

  task :stop do
    deploy.stop_app
    deploy.stop_mq
    deploy.stop_db
  end

  task :stop_app, :roles => :app do
  end
  task :stop_mq, :roles => :mq do
  end
  task :stop_db, :roles => :db do
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  desc "[internal][override] This is called by update_code"
  task :finalize_update, :except => { :no_release => true } do
    run "chmod -R g+w #{latest_release}" if fetch(:group_writable, true)

    # mkdir -p is making sure that the directories are there for some SCM's that don't
    # save empty folders
    run <<-CMD
      rm -rf #{latest_release}/log #{latest_release}/public/system #{latest_release}/tmp/pids &&
      mkdir -p #{latest_release}/public &&
      mkdir -p #{latest_release}/tmp &&
      ln -s #{shared_path}/log #{latest_release}/log &&
      ln -s #{shared_path}/system #{latest_release}/public/system &&
      ln -s #{shared_path}/pids #{latest_release}/tmp/pids
    CMD

    # rails3.1だとimageファイル系のファイルの配置が変わってるので上書きします
    # 以下を $RAIL_ROOT/app/assets を指定するようにしてもよいですが、まずは deploy 毎に最新取得する対象にしておきます。
    #
    # if fetch(:normalize_asset_timestamps, true)
    #   stamp = Time.now.utc.strftime("%Y%m%d%H%M.%S")
    #   asset_paths = fetch(:public_children, %w(images stylesheets javascripts)).map { |p| "#{latest_release}/public/#{p}" }.join(" ")
    #   run "find #{asset_paths} -exec touch -t #{stamp} {} ';'; true", :env => { "TZ" => "UTC" }
    # end
  end
end

# capistrano force stop for 'ctl+c'
Signal.trap(:INT) do
  abort "\n[cap] Inturrupted..."
end
