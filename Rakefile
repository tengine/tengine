# -*- coding: utf-8 -*- 
#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

TengineConsole::Application.load_tasks


require 'cucumber/rake/task'

E2E_OPTS = ["--format", "pretty", "--strict", "--tags", "~@wip", "--tags", "~@manual", "-r", "features"]

FEATURE_DIR = "features/usecases"

Cucumber::Rake::Task.new("cucumber:uc01", "uc01") do |task|
  usecase_file = "features/usecases/コア/アプリケーション運用者がイベント通知画面で問題を知る.feature"
  task.cucumber_opts = E2E_OPTS + [usecase_file]
end
