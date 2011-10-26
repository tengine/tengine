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

# capistrano force stop for 'ctl+c'
Signal.trap(:INT) do
  abort "\n[cap] Inturrupted..."
end
