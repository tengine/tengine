# -*- coding: utf-8 -*-

##############################
# setting server and roles
##############################
role :web, "tgnweb001", "tgnweb002"
role :app, "tgnweb001", "tgnweb002"
role :db,  "tgnweb001", :primary => true # This is where Rails migrations will run
role :db,  "tgnweb002"

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

# default は, tar だが mac 標準の tar は bsdtar で gnutar ではないので zip にする
set :copy_compression,  :zip
set :deploy_via,        :copy
set :deploy_to,         "/var/lib/#{application}"
set :deploy_env,        "production"
set :bundle_dir,        "./vendor/bundle"

set :keep_releases,     3
# rails3.0 以下のディレクトリ構成のエラーを無視する
set :normalize_asset_timestamps, false
