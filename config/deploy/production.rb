# -*- coding: utf-8 -*-

##############################
# setting server and roles
##############################
role :app,            "tengine_core1", "tengine_core_2"
role :load_dsl,       "tengine_core1"
role :enable_drivers, "tengine_core1"

set :use_sudo,    false
set :user,        'root'
set :password,    'password'
set :ssh_options, {
  :forward_agent => true
}


##############################
# tasks
##############################
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

### デプロイ手順 ###
# 1. cap production ROLE=app deploy:setup
# 2. cap production ROLE=app deploy:update
# 3. cap production ROLE=app deploy:bundle
# 4. cap production deploy:start

set :num_proc,         '2' # 起動するカーネルのプロセス数
set :load_dir,         "#{current_path}/app"
set :load_path,        "#{load_dir}"
set :config_file_path, "#{shared_path}/config/tengined.yml"

### 自動ロールバック
# 1. エラーが起きたことがわかる
# 2. Tengineコアが起動していたら、強制停止

namespace :deploy do
  task :start do
    load_dsl

    transaction do
      num_proc.to_i.times { start_kernel }
      wait_until_waiting_activation
      enable_drivers
    end

    deploy.activate
  end
  after "deploy:start", "deploy:cleanup"

  task :load_dsl, :roles => :load_dsl do
    run "cd #{current_path} && tengined -k load -T #{load_path} -f #{config_file_path} --tengined-skip-enablement"
  end

  task :start_kernel, :roles => :app do
    on_rollback do
      force_stop
      abort "=== could not start kernel process. ==="
    end

    run (<<-CMD).split.join(" ")
      cd #{current_path} && tengined -D -T #{load_path} --tengined-skip-load -f #{config_file_path} --tengined-wait-activation
    CMD
  end

  task :wait_until_waiting_activation, :roles => :app do
    # waiting_activationになるまで待つ, terminatedは無視
    #   STATUS_LIST = [ # Tengine::Core::Kernel
    #     :initialized,        # 初期化済み
    #     :starting,           # 起動中
    #     :waiting_activation, # 稼働要求待ち
    #     :running,            # 稼働中
    #     :shutting_down,      # 停止中
    #     :terminated,         # 停止済
    #   ].freeze

    # waiting_activationが起動プロセス数分あること
    run (<<-CMD).split.join(" ")
      cd #{current_path} && \
      echo Waiting for being waiting_activation... && \
      echo ex\\) \\{ pid \\=\\> status \\} && \
      ruby -e 'begin stats=IO.popen("tengined -k status"){|io| io.read}.split("\\n").map(&:strip).inject({}){|m, e| i=e.split; m[i[0]]=i[1]; m}; res=stats.select{|k,v| v.to_sym == :waiting_activation}.count == #{num_proc}; puts stats.reject{|k,v| v.to_sym == :terminated}; sleep 3 end until res'
    CMD
  end

  task :enable_drivers, :roles => :enable_drivers do
    run "cd #{current_path} && tengined -k enable -T #{load_path} -f #{config_file_path}"
  end

  task :activate, :roles => :app do
    run "cd #{current_path} && tengined -k activate -f #{config_file_path}"
  end

  task :bundle, :roles => :app do
    run "cd #{current_path} && bundle"
  end

  task :stop, :roles => :app do
    run "cd #{current_path} && tengined -k stop -f #{config_file_path}"
  end

  task :force_stop, :roles => :app do
    run "cd #{current_path} && tengined -k force_stop -f #{config_file_path}"
  end

end
