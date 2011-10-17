# -*- coding: utf-8 -*-
##############################
# setting server and roles
##############################
role :app,            "core1.tenginefw.com", "core2.tenginefw.com"
role :load_dsl,       "core1.tenginefw.com"
role :enable_drivers, "core1.tenginefw.com"

set :use_sudo,    false
set :user,        'root'
set :password,    'password'
set :ssh_options, {
  :forward_agent => true
}
