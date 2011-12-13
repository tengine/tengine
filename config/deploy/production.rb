# -*- coding: utf-8 -*-

##############################
# setting server and roles
##############################
role :web, "zbtgncr1", "zbtgncr2"
role :app, "zbtgncr1"
role :db,  "zbtgncr1"

set :user,              'tengine'
set :password do
  Capistrano::CLI.password_prompt('SSH Password: ')
end
set :use_sudo,          true
set :ssh_options, {
  :forward_agent => true,
  # :keys => [File.join(ENV["HOME"], ".ssh", "id_rsa")],
}
default_run_options[:pty] = true

##############################
# setting scm
##############################
set :scm_verbose,       true
set :scm_user do
  Capistrano::CLI.ui.ask('SCM User: ')
end
set :scm_password do
  Capistrano::CLI.password_prompt('SCM Password: ')
end

set :scm,               :none
set :repository,        "."

# default は, tar だが mac 標準の tar は bsdtar で gnutar ではないので zip にする
set :copy_compression,  :zip
set :copy_cache,        false
set :copy_strategy,     :export
set :copy_exclude,      ['.git', '.svn']

set :deploy_via,        :copy
set :deploy_to,         "/var/lib/#{application}"
set :deploy_env,        "production"
set :bundle_dir,        "./vendor/bundle"

set :keep_releases,     3
# rails3.0 以下のディレクトリ構成のエラーを無視する
set :normalize_asset_timestamps, false
