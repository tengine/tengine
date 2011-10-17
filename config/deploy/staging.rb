# -*- coding: utf-8 -*-
##############################
# setting server and roles
##############################
role :app,            "dev1.tenginefw.com", "dev2.tenginefw.com"
role :load_dsl,       "dev1.tenginefw.com"
role :enable_drivers, "dev1.tenginefw.com"

set :use_sudo,    false
set :user,        'root'
set :password,    'password'
set :ssh_options, {
  :forward_agent => true
}
